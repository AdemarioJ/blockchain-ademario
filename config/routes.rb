Rails.application.routes.draw do

  # Devise
  devise_for :users, controllers: { sessions: 'sessions' }
  devise_scope :user do
    root to: 'blockchains#index'
  end

  # Transacion
  resources :transactions, only: [:show, :create, :new]

  # Blockchain
  resources :blockchains, only: [:show, :create, :new]
  get 'blockchain', to: 'blockchains#index'
  post 'update_informations', to: 'blockchains#update_informations'
  post 'get_transactions', to: 'blockchains#get_transactions_block'

  # get 'users', to: 'users#index'
  resources :users, only: [:index, :show]
  put 'users/reset_password/:id' => 'users#reset_password'

end
