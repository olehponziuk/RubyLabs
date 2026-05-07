Rails.application.routes.draw do
  resources :categories
  resources :ingredients

  resources :recipes do
    collection do
      get :published
    end
  end

  root "recipes#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
