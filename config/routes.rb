Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  namespace :api do
    resources :policies, only: [ :index, :create, :show ] do
      resources :endorsements, only: [ :index, :create, :show ]
    end
  end
end
