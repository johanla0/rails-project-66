# frozen_string_literal: true

class CheckRepositoryJob
  include Sidekiq::Job

  sidekiq_options retry: 0

  def perform(check_id)
    check = Repository::Check.find check_id
    return if check.blank?

    Repository::CheckService.run!(check)
  end
end
