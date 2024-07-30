Rails.application.routes.draw do
  resources :slack_members, only: %i(index edit update destroy)
  resources :books, only: %i(index edit update) do
    member do
      post :rental
      post :want_to_read
      post :return
    end
  end
  resources :orders do
    member do
      post :purchase
    end
    collection do
      get :extract_amazon_product_info
    end
  end
  root to: 'top#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
