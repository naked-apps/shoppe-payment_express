require 'shoppe/payment_express/version'
require 'shoppe/payment_express/engine'

require 'shoppe/payment_express/order_extensions'

require 'shoppe/payment_express/errors/configuration_missing'
require 'shoppe/payment_express/errors/invalid_payment_url'

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

      def configure(configuration)
        self.configuration ||= Shoppe::PaymentExpress::Configuration.new
        yield(configuration)
      end

    end

    class Configuration
      attr_accessor :order_not_found_route, :return_after_payment_route

      def initialize
        @order_not_found_route = 'root'
        @return_after_payment_route = 'root'
      end
    end

  end
end