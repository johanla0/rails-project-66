# frozen_string_literal: true

class UserService
  class << self
    def fetch_repositories!(user)
      client = octokit_client(user)
      client.repos.select { |r| r[:language].present? && Repository::SUPPORTED_LANGUAGES.include?(r[:language].downcase.to_sym) }
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
