# frozen_string_literal: true

class UpdateRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find repository_id
    return if repository.blank?

    RepositoryMutator.update!(repository)
  end
end
