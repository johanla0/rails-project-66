# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    check = Repository::Check.find check_id
    return if check.blank?

    Repository::CheckService.run!(check)
  end
end
