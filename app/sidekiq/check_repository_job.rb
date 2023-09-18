# frozen_string_literal: true

class CheckRepositoryJob
  include Sidekiq::Job

  def perform(repository_id)
    repository = Repository.find repository_id
    return if repository.blank?

    check = Repository::Check.create(repository:)
    check.start!

    check.finish!
    true
  ensure
    FileUtils.rm_r repository.directory, force: true
  end
end
