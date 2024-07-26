# config/routes.rb
Rails.application.routes.draw do
  root 'sessions#new'  # Assuming you have a home page or login page

  get '/signin', to: 'sessions#signin'
  get '/signout', to: 'sessions#signout'
  get '/auth/oauth/callback', to: 'sessions#callback'
  get '/client_credentials', to: 'sessions#client_credentials'
  get '/token', to: 'sessions#token'
  get '/wares', to: 'sessions#wares'
  get '/providers', to: 'sessions#providers'

  # New routes for fetching data
  get '/fetch_user_profile', to: 'sessions#fetch_user_profile'
  get '/fetch_organizations_data', to: 'sessions#fetch_organizations_data'
  get '/fetch_action_items', to: 'sessions#fetch_action_items'
end
