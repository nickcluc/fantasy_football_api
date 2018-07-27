Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  namespace :api do
    namespace :v1 do
      resources :owners, only: [:index]
      resources :teams, only: [:show]
    end
  end
end
