Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  namespace :api do
    namespace :v1 do
      resources :owners, only: [:index]
      resources :teams, only: [:index]
      resources :team_matchups, only: [:index]
      resources :seasons, only: [:index]
    end
  end
end
