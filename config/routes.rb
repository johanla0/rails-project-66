# frozen_string_literal: true

Rails.application.routes.draw do
  root 'web/welcome#show'

  namespace :api do
    resources :github_webhooks, only: :create, as: 'checks'
    # scope module: :github_webhooks do
    #   post 'checks'
    # end
  end

  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/logout', to: 'auth#destroy'

    resources :repositories, only: %i[index show new create] do
      scope module: :repositories do
        resources :checks, only: %i[show create]
      end
    end
  end
end
