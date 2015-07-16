Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#welcome'

  get 'register', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'
  get 'home', to: 'videos#index'

  resources :users, only: [:new, :create, :show]

  get 'forgot_password', to: 'forgotten_passwords#new'
  get 'forgot_password/confirm', to: 'forgotten_passwords#confirm'
  resources :forgotten_passwords, only: [:create]
  resources :reset_passwords, only: [:show, :create]

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
    end

    resources :reviews, only: [:create]
  end

  resources :categories, only: [:show]

  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]

  resources :queue_items, only: [:create, :destroy]
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'

end
