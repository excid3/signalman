Signalman::Engine.routes.draw do
  resources :requests
  resources :jobs
  resources :cache
  resources :exceptions
  resources :mail
  resources :queries
  resources :views

  root "requests#index"
end
