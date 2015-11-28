module Shoppe
  module PaymentExpress
    module OrderExtensions

      def create_paymentexpress_payment(params)
        if paymentexpress_payment_approved?(params) && paymentexpress_payment_valid?(params)
          payment = Shoppe::Payment.new
          payment.method = "PaymentExpress"
          payment.reference = params[:id]
          payment.amount = BigDecimal(params[:amount]) / BigDecimal(100)
          payment.order = self
          payment.save!
          true
        else
          false
        end
      end

      def paymentexpress_payment_parameters
        params = {
          price: self.total.round(2).to_s,
          description: self.id,
          email: self.email_address,
          address1: self.billing_address1,
          city: self.billing_address3,
          state: self.billing_address4,
          zip: self.billing_postcode,
          country: self.billing_country.name,
          name: self.full_name,
          custom: self.token
        }
        params
      end

      def paymentexpress_payment_approved?(params)
        return false if params[:status] != "Transaction approved"
        true
      end

      def paymentexpress_payment_valid?(params)
        return false if self.token.to_s != params[:custom].to_s
        return false if self.id.to_s != params[:reference].to_s
        return false if self.email_address.to_s.downcase != params[:email].to_s.downcase
        true
      end

    end
  end
end
