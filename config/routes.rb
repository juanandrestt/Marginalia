Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :users, only: [:show] do
    member do
      get :followers
      get :following
    end
  end

  resources :chats, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  resources :lists, only: [:index, :new, :create, :show, :destroy] do
    resources :bookmarks, only: [:new, :create, :destroy]
  end

  resources :books, only: [:index, :show] do
    resources :reviews, only: [:new, :create, :edit, :update, :destroy]
    resources :bookclubs, only: [:new, :show, :create, :edit, :update, :destroy, :index]
  end

  resources :follows, only: [:create, :destroy]
  resources :bookclubs, only: [:index]

  get 'search', to: 'searchs#index', as: :search
  get "/books", to: "books#index", as: :all_books
  get '/dashboard', to: 'pages#dashboard'
end
