Rails.application.routes.draw do
  
  resources :transactions, only: [:show, :create, :new]

  resources :blockchains, only: [:show, :create, :new]

  get 'blockchain', to: 'blockchains#index'
  post 'update_informations', to: 'blockchains#update_informations'
  post 'get_transactions', to: 'blockchains#get_transactions_block'

end
