Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root "users#new"

  resources :users, only: [:new, :create]
  resources :short_url_generators, only: [:new, :create]
  get "/login", to: "users#login"
  post "/login", to: "users#login"
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do
        collection do
          post :login
        end
      end
      resources :short_url_generators, only: [:create]
    end
  end
  get "/:short_url", to: "api/v1/short_url_generators#short_url"
end
