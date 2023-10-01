# frozen_string_literal: true

class RepositoryService
  class << self
    def create!(user, repository_params)
      RepositoryMutator.create!(user, repository_params)
    end

    def check!(repository)
      CheckRepositoryJob.perform_async(repository.id)
    end

    def shallow_clone!(repository)
      user_directory = repository.user.decorate.directory_path
      FileUtils.mkdir_p(user_directory)
      Dir.chdir(user_directory)

      github_repository = UserService.fetch_repository!(repository.user, repository)
      begin
        Git.clone(github_repository[:clone_url], nil, depth: 1)
      rescue Git::FailedError => e
        Rails.logger.error(e.message)
        Sentry.capture_exception(e)
        nil
      end
    end

    def destroy!(repository)
      # TODO: stop running and scheduled jobs for this repo?
      # Destroy repository
    end
  end
end
