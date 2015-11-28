require 'shoppe/paymentexpress/version'
require 'shoppe/paymentexpress/engine'

require 'shoppe/paymentexpress/order_extensions'

require 'shoppe/paymentexpress/errors/account_name_undefined'

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

      def setup
        # Set the configuration which we would like
        Shoppe.add_settings_group :paymentexpress, [:paymentexpress_user_id, :paymentexpress_pxpay_key]
      end

      def configure
        self.configuration ||= Shoppe::PaymentExpress::Configuration.new
        yield(configuration)
      end

    end

    class Configuration
      attr_accessor :callback_path, :order_not_found_route, :return_after_payment_route

      def initialize
        @callback_path = 'payment'
        @order_not_found_route = 'root'
        @return_after_payment_route = 'root'
      end
    end

  end
end