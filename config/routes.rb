Rails.application.routes.draw do
  devise_for :users

  post '/check_in', to: 'visit#create'
  delete '/check_out', to: 'visit#delete'

  root to: 'home#index'
end
