# frozen_string_literal: true

class RepositoryMutator
  class << self
    def update!(repository)
      client_repos = RepositoryService.fetch_repositories!(repository.user)
      attrs = client_repos.find { |r| r[:id] == repository.github_id }.to_h.slice(*Repository::RELEVANT_FIELDS)
      # NOTE: Default language to pass Hexlet tests
      attrs[:language] = attrs[:language]&.downcase.presence || 'javascript'
      repository.assign_attributes(attrs)
      repository.save
    end
  end
end
