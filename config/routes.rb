# config/routes.rb
Rails.application.routes.draw do
  root 'sessions#new'  # Assuming you have a home page or login page

  get '/signin', to: 'sessions#signin'
  get '/signout', to: 'sessions#signout'
  get '/auth/oauth/callback', to: 'sessions#callback'
  get '/client_credentials', to: 'sessions#client_credentials'
  get '/token', to: 'sessions#token'
  get '/user', to: 'sessions#user'
  get '/wares', to: 'sessions#wares'
  get '/providers', to: 'sessions#providers'
end
