# frozen_string_literal: true

class CheckRepositoryJob
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(repository_id)
    repository = Repository.find repository_id
    return if repository.blank?

    Repository::CheckService.create!(repository)
  end
end
