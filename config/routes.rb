# frozen_string_literal: true

Rails.application.routes.draw do
  get "rental_vehicles/new"
  get "rental_vehicles/create"
  get "rentals/new"
  get "rentals/create"
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/home", to: "static_pages#home"
    get "/contact", to: "static_pages#contact"
    resources :vehicle_details do
      collection do
        get "models"
      end
    end
    resource :session
    resources :models
    resources :cart_items do
      patch :update_quantity, on: :member
    end

    namespace :admin do
      resources :rentals do
        member do
          patch :approve
          patch :reject
          patch :rent
          patch :return
        end
        resources :proofs, only: %i[create destroy]
      end
    end

    namespace :user do
      resources :rentals do
        member do
          patch :cancel
        end
      end
    end
  end
end
