require 'HTTParty'

module Shoppe
  module PaymentExpress
    class PaymentsController < ApplicationController

      skip_before_action :verify_authenticity_token, only: [:pay, :process_callback]
      skip_filter :login_required

      def process_callback
        details = transaction_details(params.permit(:result)[:result])

        # Have we been successful?
        if details['Success'].to_s == '1'
          # Firstly, the order must exist
          unless order = Shoppe::Order.find_by_token(details['MerchantReference'])
            order_not_found_path = Rails.application.routes.url_helpers.send("#{Shoppe::PaymentExpress.configuration.order_not_found_route}_url")
            redirect_to order_not_found_path, alert: "Sorry, we couldn't actually find your order.  Please try again."
            return
          end
          # If not yet accepted, accept it!
          if order.status == 'received' && order.create_paymentexpress_payment(details)
            order.accept!
          end
        end

        # Redirect to the status - we do this even if the payment failed
        # Maybe we should allow them to retry payment from the order status page?
        redirect_to return_after_payment_url(details['MerchantReference'])
      end

      def pay
        unless order = Shoppe::Order.find_by_token(params[:order_token])
          order_not_found_path = Rails.application.routes.url_helpers.send("#{Shoppe::PaymentExpress.configuration.order_not_found_route}_url")
          redirect_to order_not_found_path, alert: "Sorry, we couldn't actually find your order.  Please try again."
          return
        end

        # Ensure we have the correct settings
        user_id = Shoppe.settings.paymentexpress_pxpay_user_id
        key = Shoppe.settings.paymentexpress_pxpay_key
        currency_code = Shoppe.settings.paymentexpress_currency_code
        raise Shoppe::PaymentExpress::Errors::ConfigurationMissing unless user_id.present? && key.present? && currency_code.present?

        # Get the URI from Payment Express
        payment_params = order.paymentexpress_payment_parameters
        xml = build_generate_request_xml(user_id, key, currency_code, payment_params)
        response = HTTParty.post(payment_url, { body: xml })
        # Extract the payment URL from the response
        redirect_url = URI(response["Request"]["URI"]) rescue nil
        raise Shoppe::PaymentExpress::Errors::InvalidPaymentURL unless redirect_url.kind_of?(URI::HTTPS)

        # Redirect the user to the payment page
        redirect_to redirect_url.to_s
      end


      private

      def transaction_details(result_token)
        # Ensure we have the correct settings
        user_id = Shoppe.settings.paymentexpress_pxpay_user_id
        key = Shoppe.settings.paymentexpress_pxpay_key
        raise Shoppe::PaymentExpress::Errors::ConfigurationMissing unless user_id.present? && key.present?
        # Get the transaction details from Payment Express
        xml = build_process_response_xml(user_id, key, result_token)
        response = HTTParty.post(payment_url, { body: xml })
        response['Response']
      end

      def build_process_response_xml(user_id, key, result_token)
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.ProcessResponse {
            xml.PxPayUserId user_id
            xml.PxPayKey key
            xml.Response result_token
          }
        end
        builder.doc.root.to_xml
      end

      def build_generate_request_xml(user_id, key, currency_code, params)
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.GenerateRequest {
            xml.PxPayUserId user_id
            xml.PxPayKey key
            xml.TxnType 'Purchase'
            xml.CurrencyInput currency_code
            xml.AmountInput params[:amount_input]
            xml.MerchantReference params[:merchant_reference]
            xml.TxnData1 params[:txn_data_1]
            xml.TxnData2 params[:txn_data_2]
            xml.TxnData3 params[:txn_data_3]
            xml.UrlSuccess callback_url
            xml.UrlFail callback_url
          }
        end
        builder.doc.root.to_xml
      end

      def payment_url
        return "https://sec.paymentexpress.com/pxaccess/pxpay.aspx"
        if Rails.env.production?
          "https://sec.paymentexpress.com/pxaccess/pxpay.aspx"
        else
          "https://uat.paymentexpress.com/pxaccess/pxpay.aspx"
        end        
      end

      def callback_url 
        Rails.application.routes.url_helpers.send("payment_express_callback_url", host: request.host)
      end

      def return_after_payment_url(identifier)
        route = Shoppe::PaymentExpress.configuration.return_after_payment_route
        identifier_key = Rails.application.routes.named_routes[route].required_parts.first
        Rails.application.routes.url_helpers.send("#{route}_url", host: request.host, identifier_key => identifier)
      end

    end
  end
end