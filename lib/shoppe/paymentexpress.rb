require 'shoppe/paymentexpress/version'
require 'shoppe/paymentexpress/engine'

require 'shoppe/paymentexpress/order_extensions'

require 'shoppe/paymentexpress/errors/configuration_missing'

module Shoppe
  module PaymentExpress

    class << self

      attr_accessor :configuration

      def pxpay_user_id
        Shoppe.settings.paymentexpress_pxpay_user_id
      end

      def pxpay_key
        Shoppe.settings.paymentexpress_pxpay_key
      end

      def currency_code
        Shoppe.settings.paymentexpress_currency_code
      end

      def setup
        # Set the configuration which we would like
        Shoppe.add_settings_group :payment_express, [:paymentexpress_pxpay_user_id, :paymentexpress_pxpay_key, :paymentexpress_currency_code]
      end

      def configure
        self.configuration ||= Shoppe::PaymentExpress::Configuration.new
        yield(configuration)
      end

    end

    class Configuration
      attr_accessor :order_not_found_route, :return_after_payment_route, :return_after_payment_success_route, :return_after_payment_failure_route

      def initialize
        @order_not_found_route = 'root'
        @return_after_payment_success_route = 'root'
        @return_after_payment_failure_route = 'root'
      end
    end

  end
end