Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users

  resources :messages, only: [:index, :new, :create]
  resources :lists, only: [:new, :create, :destroy] do
    resources :bookmarks, only: [:new, :create]
  end

  resources :books, only: [:index, :show] do
    resources :reviews, only: [:new, :create, :edit, :update, :destroy]
    resources :bookclubs, only: [:new, :show, :create, :edit]
  end

  resources :bookclubs, only: [:index]

  get 'search', to: 'searchs#index', as: :search
  get "/books", to: "books#index", as: :all_books
end
