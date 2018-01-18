Rails.application.routes.draw do
  root 'dashboard#index'

  resources :accounts do
    resources :transactions
  end

  resources :transactions

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
