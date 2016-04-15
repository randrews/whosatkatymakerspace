Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'registrations',
    omniauth_callbacks: "omniauth_callbacks"
  }

  post '/check_in', to: 'visit#create'
  get '/check_in', to: 'visit#create'
  delete '/check_out', to: 'visit#delete'
  get '/qr', to: 'visit#toggle'
  resources :visit, only: [:update, :show]
  post '/users/:id/check_out', to: 'users#check_out', as: 'force_check_out'
  post '/users/:id/approve', to: 'users#approve', as: 'approve_user'
  delete '/users/:id', to: 'users#delete', as: 'delete_user'

  root to: 'home#index'
end
