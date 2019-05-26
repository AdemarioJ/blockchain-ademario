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

  # Session
  get    'sign_in'   => 'sessions#new'
  post   'sign_in'   => 'sessions#create'
  delete 'sign_out'  => 'sessions#destroy'
  get 'sessions/new'

  # User
  get 'user/create'
  get 'user/index'
  get 'user/show'
  get 'user/edit'
  get 'user/reset_pasword'

end
