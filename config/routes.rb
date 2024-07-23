Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  Rails.application.routes.draw do
    root 'sessions#new'
    get '/auth/:provider/callback', to: 'sessions#callback'
    post '/auth/rx', to: 'sessions#create'
  end

end
