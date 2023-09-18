# frozen_string_literal: true

class RepositoryService
  class << self
    def create!(user, repository_params)
      repository = RepositoryMutator.create!(user, repository_params)
      check!(repository)
      repository
    end

    def check!(repository)
      CheckRepositoryJob.perform_async(repository.id)
    end

    def destroy!(repository)
      # TODO: stop running jobs for this repo
      # Destroy repository
    end
  end
end
