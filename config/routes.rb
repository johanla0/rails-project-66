# frozen_string_literal: true

Rails.application.routes.draw do
  root 'web/welcome#index'

  namespace :api do
    post 'checks', to: 'webhooks#github'
  end

  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/logout', to: 'auth#destroy'

    resources :repositories, only: %i[index show new create destroy] do
      scope module: :repositories do
        resources :checks, only: %i[show create]
      end
    end
  end
end
