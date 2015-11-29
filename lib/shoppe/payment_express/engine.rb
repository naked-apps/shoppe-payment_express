module Shoppe
  module PaymentExpress
    class Engine < Rails::Engine

      initializer "shoppe.payment_express.initializer" do
        Shoppe::PaymentExpress.setup
      end

      config.to_prepare do
        Shoppe::Order.send :include, Shoppe::PaymentExpress::OrderExtensions
      end

    end
  end
end
