Rails.application.routes.draw do
  scope module: :shoppe do
    namespace :payment_express do
      get 'pay/:order_token', to: 'payments#pay', as: 'payment'
      get 'callback', to: 'payments#process_callback', as: 'callback'
    end
  end
end