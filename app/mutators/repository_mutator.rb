# frozen_string_literal: true

class RepositoryMutator
  class << self
    def create!(user, repository_params)
      repository = user.repositories.build(repository_params)

      client_repos = UserService.fetch_repositories!(user)
      attrs = client_repos.find { |r| r[:id] == repository.github_id }.to_h.slice(*Repository::RELEVANT_FIELDS)
      return repository if attrs[:language].nil?

      attrs[:language] = attrs[:language].downcase
      repository.assign_attributes(attrs)
      repository.save

      repository
    end
  end
end
