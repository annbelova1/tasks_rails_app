Rails.application.routes.draw do
  root 'home#index'
  get 'persons/profile', as: 'user_root'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount RestAPI => '/api'

  devise_for :users

  resource :logins, only: %i[show create destroy]
  resources :tasks do
    patch :start, on: :member
    patch :cancel, on: :member
    patch :complete, on: :member
    patch :approve, on: :member
  end
end
