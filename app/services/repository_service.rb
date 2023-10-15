# frozen_string_literal: true

class RepositoryService
  class << self
    def shallow_clone!(repository)
      # NOTE: Need to create directory manually, otherwise Git.clone tries to use
      # destination path which already exists and is not an empty directory
      user_directory = repository.user.directory_path
      FileUtils.mkdir_p(user_directory)
      Dir.chdir(user_directory)

      # NOTE: Need to fetch, in other case we have job being stuck
      # This does not work Git.clone(repository[:git_url], nil, depth: 1)
      github_repository = RepositoryService.fetch_repository!(repository.user, repository)
      begin
        Git.clone(github_repository[:clone_url], nil, depth: 1)
      rescue Git::FailedError => e
        Rails.logger.error(e.message)
        Sentry.capture_exception(e)
        nil
      end
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
