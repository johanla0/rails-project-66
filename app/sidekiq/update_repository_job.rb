# frozen_string_literal: true

class UpdateRepositoryJob
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(repository_id)
    repository = Repository.find repository_id
    return if repository.blank?

    RepositoryMutator.update!(repository)
  end
end
