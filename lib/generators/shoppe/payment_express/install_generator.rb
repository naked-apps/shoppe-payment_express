module Shoppe
  module PaymentExpress
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path("../../../templates", __FILE__)
        desc "Creates PaymentExpress initializer for your application"

        def copy_initializer
          template "payment_express_initializer.rb", "config/initializers/payment_express.rb"

          puts "Install complete!"
        end
      end
    end
  end
end