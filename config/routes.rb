# frozen_string_literal: true

Rails.application.routes.draw do
  root 'web/welcome#index'

  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/logout', to: 'auth#destroy'

    resources :repositories, only: %i[index show new create destroy] do
      post :checks
    end

    scope module: :repositories do
      resources :repositories, only: [] do
        resources :checks, only: :show
      end
    end
  end
end
