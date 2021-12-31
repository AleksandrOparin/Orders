Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root 'orders#index'

    get 'orders/orders'
    get 'orders/take'
    get 'orders/remove'
    get 'orders/take_orders'
    get 'orders/complete'
    get 'orders/complete_orders'
    
    get 'session/login'
    post 'session/create'
    get 'session/logout'
    resources :users
    resources :orders
  end
end
