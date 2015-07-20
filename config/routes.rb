Flixster::Application.routes.draw do

  root 'pages#front'
  get '/expired_token' => 'pages#expired_token'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: :index
  end

  get '/home' => 'videos#index'
  get '/videos/:id/watch' => 'videos#watch', as: :watch_video

  resources :videos, only: :show do
    get "search", on: :collection
    resources :reviews, only: :create
  end

  get '/register' => 'users#new'
  get 'invited_register/:token' => 'users#invited_registration', as: :invited_register
  resources :users, only: [:show, :create]

  resources :password_resets, only: [:new, :create, :edit, :update]

  get '/people' => 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  get '/my_queue' => 'queue_items#index'
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue' => 'queue_items#update_queue'

  resources :categories, only: :show

  resources :invitations

  mount StripeEvent::Engine => '/stripe_events'
end
