Rails.application.routes.draw do
  root 'dashboard#index'

  resources :accounts do
    resources :transactions
  end

  resources :transactions
  
  resources :imports

  resources :parsers

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
