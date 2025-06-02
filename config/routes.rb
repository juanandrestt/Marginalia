Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get '/dashboard', to: 'pages#dashboard'

  resources :users, only: [:show, :edit, :update] do
    member do
      get :followers
      get :following
    end
  end

  resources :follows, only: [:create, :destroy]
  resources :chats, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  resources :books, only: [:index, :show, :new, :create] do
    resources :reviews, only: [:new, :create, :edit, :update, :destroy]
    resources :bookclubs, only: [:new, :create]
  end

  resources :lists, only: [:index, :new, :create, :show, :destroy] do
    resources :bookmarks, only: [:new, :create, :destroy]
  end

  resources :bookclubs, only: [:index, :show, :edit, :update, :destroy]

  resources :searches, only: [:index], path: 'search'
end
