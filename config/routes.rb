Signalman::Engine.routes.draw do
  resources :requests
  resources :jobs
  resources :cache
  resources :exceptions
  resources :mails
  resources :queries
  resources :views

  namespace :generators do
    resource :scaffold
    resource :model
  end

  root "requests#index"
end
