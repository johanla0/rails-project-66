# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  root 'web/welcome#show'

  namespace :api do
    resources :github_webhooks, only: :create, path: 'checks', as: 'checks'
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

  scope :monitoring do
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # Protect against timing attacks:
      # - See https://codahale.com/a-lesson-in-timing-attacks/
      # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
      ActiveSupport::SecurityUtils.secure_compare(Digest::SHA256.hexdigest(username), Digest::SHA256.hexdigest(Rails.application.credentials.dig(:sidekiq, :username))) &
        ActiveSupport::SecurityUtils.secure_compare(Digest::SHA256.hexdigest(password), Digest::SHA256.hexdigest(Rails.application.credentials.dig(:sidekiq, :password)))
    end
    mount Sidekiq::Web, at: '/sidekiq'
  end
end
