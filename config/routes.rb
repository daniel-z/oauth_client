Rails.application.routes.draw do
  root 'sessions#new'
  get '/auth/oauth/callback', to: 'sessions#callback'
  post '/auth/initiate', to: 'sessions#create'
end
