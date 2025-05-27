Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users

  resources :messages, only: [:index, :new, :create]
  resources :lists, only: %i[ new create destroy] do
    resources :bookmarks, only: %i[new create]
  end

  resources :books, only: %i[index show] do
    resources :reviews, only: [:new, :create]
  end
  get 'search', to: 'searchs#index', as: :search
end
