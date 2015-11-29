require 'shoppe/paymentexpress/callback_constraint'

Rails.application.routes.draw do
  scope module: :shoppe do
    namespace :paymentexpress do
      get 'pay/:order_token', to: 'payments#pay', as: 'payment'
      post 'pay/callback', to: 'payments#process_callback', as: 'payment_callback'
    end
  end
end