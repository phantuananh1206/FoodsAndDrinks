Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    get "/search", to: "searchs#index"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/clear-cart", to: "carts#clear_cart", as: :clear_cart
    post "/orders/new", to: "orders#voucher"
    delete "/orders/new", to: "orders#cancel_voucher"
    get "/edit_password", to: "users#edit_password"
    patch "/edit_password", to: "users#update_password"
    resources :products, only: :show do
      resources :ratings, only: %i(index create)
    end
    resources :categories, only: :show
    resources :users do
      resources :orders, only: %i(index show update) do
        resources :order_details, only: :index
      end
    end
    resources :carts, except: %i(show edit new)
    namespace :admin do
      root "base#home"
      resources :orders, only: %i(index update)
    end
    resources :orders, only: %i(new create)
    resources :account_activations, only: %i(edit)
    resources :password_resets, except: [:index, :destroy, :show]
    resources :users, only: %i(edit update)
    resources :order_confirmations, only: %i(edit)
  end
end
