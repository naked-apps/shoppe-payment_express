module Shoppe
  module PaymentExpress
    class CallbackConstraint
      def matches?(request)
        Shoppe::PaymentExpress.configuration.callback_path == request.path_parameters[:callback]
      end
    end
  end
end