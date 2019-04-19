Rails.application.routes.draw do
  
  resources :transactions, only: [:show, :create, :new]
  #get 'blockchain', to: 'transaction#index'

end
