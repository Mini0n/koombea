Rails.application.routes.draw do
  resources :import_errors
  resources :contact_files
  resources :contacts
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
