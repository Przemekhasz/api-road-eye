Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create, :update, :destroy]
      resources :recordings do
        member do
          get 'stream'
        end
      end
      post 'login', to: 'sessions#create'
    end
  end

  direct :rails_blob do |blob, options|
    route_for(:rails_service_blob, blob.signed_id, blob.filename, options)
  end

  direct :rails_blob_representation do |representation, options|
    route_for(:rails_service_blob_representation, representation.blob.signed_id, representation.variation_key, representation.blob.filename, options)
  end
end
