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
    resources :models
    resources :cart_items
    resource :session
  end
end
