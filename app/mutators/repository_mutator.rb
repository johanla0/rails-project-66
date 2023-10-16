# frozen_string_literal: true

class RepositoryMutator
  class << self
    def update!(repository)
      client_repos = RepositoryService.fetch_repositories!(repository.user)
      attrs = client_repos.find { |r| r[:id] == repository.github_id }.to_h.slice(*Repository::RELEVANT_FIELDS)
      attrs[:language] = attrs[:language]&.downcase
      repository.assign_attributes(attrs)
      repository.save
    end
  end
end
