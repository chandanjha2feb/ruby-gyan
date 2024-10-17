require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :enrollments do
    get :my_students, on: :collection
    member do
      get :certificate
    end
  end
  devise_for :users, :controllers => { 
    registrations: "users/registrations",
    omniauth_callbacks: 'users/omniauth_callbacks'  }
  resources :tags, only: [:create, :index, :destroy]
  resources :courses, except: [:edit] do
    get :purchased, :pending_review, :created, :unapproved, on: :collection
    member do
      get :analytics
      patch :approve
      patch :unapprove
    end
    resources :lessons do
      resources :comments, except: [:index]
      member do
        delete :delete_video
      end
    end
    resources :enrollments, only: [:new, :create]
    resources :course_wizard, controller: "courses/course_wizard"
  end
  resources :youtube, only: :show
  resources :users
  root 'home#index'
  get 'activity', to: 'home#activity'
  get 'analytics', to: 'home#analytics'
  get 'charts/users_per_day', to: 'charts#users_per_day'
  get 'charts/enrollments_per_day', to: 'charts#enrollments_per_day'
  get 'charts/course_popularity', to: 'charts#course_popularity'
  get 'privacy_policy', to: 'home#privacy_policy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end