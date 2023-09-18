# frozen_string_literal: true

class UserService
  class << self
    def fetch_repositories!(user)
      # NOTE: Need to cache repos
      client = ApplicationContainer[:octokit_client].new(access_token: user.token, auto_paginate: true)
      client.repos
    rescue Octokit::Error => e
      Sentry.capture_exception(e)
      []
    end
  end
end
