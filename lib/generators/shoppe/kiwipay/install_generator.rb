module Shoppe
  module PaymentExpress
    module Generators
      class InstallGenerator < Rails::Generators::Base
        source_root File.expand_path("../../../templates", __FILE__)
        desc "Creates PaymentExpress initializer for your application"

        def copy_initializer
          template "paymentexpress_initializer.rb", "config/initializers/paymentexpress.rb"

          puts "Install complete!"
        end
      end
    end
  end
end