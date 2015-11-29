Shoppe::PaymentExpress.configure do |config|
  # This is the route used for a redirect
  # when an order cannot be found after a request is
  # made to pay this order via Payment Express. This is usually
  # something like checkout, but needs to match with the
  # routes you've set in your routes.rb file.
  #
  # The default is 'root'
  #
  # config.order_not_found_route = 'checkout'

  # This is the route used to return the buyer
  # to your shop after they've made a payment with 
  # Payment Express. Either when the payment was 
  # successful or when the payment failed.
  #
  # This is usually some sort of order_status, which
  # will be called with the order token and needs
  # to match with the routes you've set in 
  # your routes.rb file.
  #
  # The default is 'root'
  #
  # config.return_after_payment_route = 'order_status'
end