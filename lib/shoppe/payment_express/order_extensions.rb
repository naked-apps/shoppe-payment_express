module Shoppe
  module PaymentExpress
    module OrderExtensions

      def create_paymentexpress_payment(params)
        if paymentexpress_payment_approved?(params) && paymentexpress_payment_valid?(params)
          payment = Shoppe::Payment.new
          payment.method = "PaymentExpress"
          payment.reference = params[:dps_txn_ref]
          payment.amount = BigDecimal(params[:amount_settlement])
          payment.order = self
          payment.save!
          true
        else
          false
        end
      end

      def paymentexpress_payment_parameters
        params = {
          amount_input: ('%.2f' % self.total).to_s,
          merchant_reference: self.token,
          email_address: self.email_address.to_s.downcase,
          txn_id: self.id,
          txn_data_1: self.full_name.to_s[0..254],
          txn_data_2: self.billing_address1.to_s[0..254],
          txn_data_3: self.billing_address2.to_s[0..254]
        }
        params
      end

      def paymentexpress_payment_approved?(params)
        return false if params[:success].to_s != '1'
        true
      end

      def paymentexpress_payment_valid?(params)
        return false if self.token.to_s != params[:merchant_reference].to_s
        return false if self.id.to_s != params[:txn_id].to_s
        return false if self.email_address.to_s.downcase != params[:email_address].to_s.downcase
        true
      end

    end
  end
end
