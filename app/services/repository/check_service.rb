# frozen_string_literal: true

class Repository::CheckService
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
  end
end
