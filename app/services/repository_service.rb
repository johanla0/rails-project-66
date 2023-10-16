# frozen_string_literal: true

class RepositoryService
  class << self
    include Rails.application.routes.url_helpers

    def create_hook!(repository)
      # NOTE: See https://docs.github.com/en/rest/webhooks/repo-config#update-a-webhook-configuration-for-a-repository
      client = octokit_client(repository.user)
      client.create_hook(
        repository.full_name,
        'web',
        {
          url: api_checks_url,
          content_type: 'json'
        },
        {
          events: ['push'],
          active: true
        }
      )
    end

    def fetch_repositories!(user)
      client = octokit_client(user)
      client.repos
    rescue Octokit::Error => e
      Rails.logger.error(e.message)
      Sentry.capture_exception(e)
      []
    end

    def fetch_repository!(user, repository)
      client = octokit_client(user)
      client.repo(repository.github_id)
    rescue Octokit::Error => e
      Rails.logger.error(e.message)
      Sentry.capture_exception(e)
      nil
    end

    private

    def octokit_client(user)
      @octokit_client ||= ApplicationContainer[:octokit_client].new(access_token: user.token, auto_paginate: true)
    end
  end
end
