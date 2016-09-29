Rails.application.routes.draw do
  root 'user_mentions#index'
  resources :user_mentions
  get '/search', to: "user_mentions#search"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
