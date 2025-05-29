Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :messages, only: [:index, :new, :create]
  resources :lists, only: [:index, :new, :create, :show, :destroy] do
    resources :bookmarks, only: [:create, :destroy]
  end

  resources :books, only: %i[index show] do
    resources :reviews, only: [:new, :create, :edit, :update, :destroy]
  end
  
  get 'search', to: 'searchs#index', as: :search
  get "/books", to: "books#index", as: :all_books
  get '/dashboard', to: 'pages#dashboard'
end
