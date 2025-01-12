Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home_pages#index"

  resource :home_page, only: :create
end
