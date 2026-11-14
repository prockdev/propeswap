Rails.application.routes.draw do
  root "listings#index"

  get    "signup", to: "users#new"
  post   "signup", to: "users#create"
  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  patch  "settings", to: "users#update_settings"

  get "sell", to: "listings#mine"
  get   "sell/requests", to: "incoming_requests#index", as: :incoming_requests
  get   "sell/requests/:id", to: "incoming_requests#show", as: :incoming_request
  get   "items/:id", to: "items#show", as: :item
  patch "sell/requests/:id/seen", to: "incoming_requests#seen", as: :seen_incoming_request
  resources :listings, only: %i[index create destroy] do
    member do
      patch :sold
      patch :renew
    end
  end

  resources :item_requests, only: %i[create update] do
    member do
      post  :no_reply
      patch :done
    end
  end

  namespace :admin do
    root "dashboard#index"
    resources :users, only: :index do
      member do
        patch :suspend
        patch :restore
      end
    end
    resources :listings, only: %i[index destroy]
    resources :actions, only: :index
  end
end
