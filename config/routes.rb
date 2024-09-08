Rails.application.routes.draw do
  resources :enrollments do
    get :my_students, on: :collection
  end
  devise_for :users
  resources :courses do
    get :purchased, :pending_review, :created, :unapproved, on: :collection
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
    resources :lessons do
      member do
        delete :delete_video
      end
    end
    resources :enrollments, only: [:new, :create]
  end
  resources :users
  root 'home#index'
  get 'activity', to: 'home#activity'
  get 'privacy_policy', to: "static_pages#privacy_policy"
  get 'analytics', to: 'home#analytics'
  get 'charts/users_per_day', to: 'charts#users_per_day'
  get 'charts/enrollments_per_day', to: 'charts#enrollments_per_day'
  get 'charts/course_popularity', to: 'charts#course_popularity'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end