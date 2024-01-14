Rails.application.routes.draw do
  # Set the root path to Articles index
  root 'articles#index'

  # RESTful routes for articles
  resources :articles
  get '/analytics', to: 'analytics#index'
  post '/record_search', to: 'articles#record_search'
  # Other routes...
  get "up" => "rails/health#show", as: :rails_health_check
end
