Rails.application.routes.draw do

  resources :blockchain, only: [:show, :create, :new]
  get 'blockchain', to: 'blockchain#index'
  get 'blockchain', to: 'blockchain#index'

  
end