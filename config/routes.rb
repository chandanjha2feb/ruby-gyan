Rails.application.routes.draw do
  resources :courses
  root 'home#index'
  get 'home/index'
  get 'privacy_policy', to: "static_pages#privacy_policy"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end