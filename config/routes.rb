Rails.application.routes.draw do
  scope module: :shoppe do
    namespace :paymentexpress do
      get 'pay/:order_token', to: 'payments#pay', as: 'payment'
      post 'callback', to: 'payments#process_callback', as: 'callback'
    end
  end
end