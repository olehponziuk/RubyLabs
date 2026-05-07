Rails.application.routes.draw do
  resources :categories
  resources :ingredients
  resources :photos

  resources :recipes do
    collection do
      get :published
      get :quick
    end
  end

  root "recipes#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
