# frozen_string_literal: true

class CheckRepositoryJob
  include Sidekiq::Job

  def perform(repository_id)
    repository = Repository.find repository_id
    return if repository.blank?

    Repository::CheckService.create!(repository)
  end
end
