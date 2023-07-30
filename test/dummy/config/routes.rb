Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount Signalman::Engine => "signalman"

  scope controller: :main do
    get :send_mail
    get :enqueue_mail
  end

  root "main#index"
end
