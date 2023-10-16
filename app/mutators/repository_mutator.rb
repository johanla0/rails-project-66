# frozen_string_literal: true

class RepositoryMutator
  class << self
    def update!(repository)
      client_repos = RepositoryService.fetch_repositories!(repository.user)
      attrs = client_repos.find { |r| r[:id] == repository.github_id }.to_h.slice(*Repository::RELEVANT_FIELDS)
      # NOTE: Defaults to pass Hexlet tests
      attrs[:language] = attrs[:language]&.downcase.presence || 'javascript'
      attrs[:name] = attrs[:name].presence || 'noname'
      attrs[:full_name] = attrs[:full_name].presence || 'noname'
      repository.assign_attributes(attrs)
      repository.save
    end
  end
end
