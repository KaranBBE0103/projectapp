Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "albums#index"
  # devise_for :users, controllers: { sessions: 'users/sessions' }
  get '/my_albums' ,to: 'albums#my_albums'

  resources :albums do
    member do
      delete :remove_video 
    end
  end

  # Defines the root path route ("/")
  # root "articles#index"
end
