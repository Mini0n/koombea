Rails.application.routes.draw do
  devise_for :users
  # get 'home/index'
  root to: 'home#index'

  resources :contact_errors, only: [:index]
  resources :contact_files, only: %i[index new create]
  resources :contacts, only: [:index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
