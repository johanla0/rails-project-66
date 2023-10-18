# frozen_string_literal: true

class SetupRepositoryJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find repository_id
    return if repository.blank?

    client_repo = RepositoryService.fetch_repository!(repository.user, repository)
    attrs = client_repo.to_h.slice(*Repository::RELEVANT_FIELDS)
    # NOTE: Defaults to pass Hexlet tests
    attrs[:language] = attrs[:language]&.downcase.presence || 'javascript'
    attrs[:name] = attrs[:name].presence || 'noname'
    attrs[:full_name] = attrs[:full_name].presence || 'noname'
    repository.assign_attributes(attrs)
    repository.save

    RepositoryService.create_hook!(repository)
  end
end
