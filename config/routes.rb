Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'registrations',
    omniauth_callbacks: "omniauth_callbacks"
  }

  post '/check_in', to: 'visit#create'
  get '/check_in', to: 'visit#create'
  delete '/check_out', to: 'visit#delete'

  root to: 'home#index'
end
