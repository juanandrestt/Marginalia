Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get '/dashboard', to: 'pages#dashboard'
  post '/create_chat', to: 'chats#create_chat', as: :quick_chat

  resources :users, only: [:show, :edit, :update] do
    member do
      get :followers
      get :following
      get :books
      get :lists
      get :bookclubs
    end
  end

  resources :follows, only: [:create, :destroy]
  resources :chats, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  resources :books, only: [:index, :show, :new, :create] do
    post 'mark_as_read', on: :member
    resources :reviews, only: [:new, :create, :edit, :update, :destroy]
    resources :bookclubs, only: [:new, :create]
  end

  resources :lists, only: [:index, :new, :create, :show, :destroy] do
    resources :bookmarks, only: [:new, :create, :destroy]
  end

  resources :bookclubs, only: [:index, :show, :edit, :update, :destroy] do
    resources :bookclub_users, only: [:create]
    resources :discussions, only: [:create]
  end

  resources :likes, only: [:destroy]
  resources :reviews, only: [] do
    resources :likes, only: [:create]
    resources :comments, only: [:index, :create]
  end
end
