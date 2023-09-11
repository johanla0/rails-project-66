# frozen_string_literal: true

class CheckRepositoryJob
  include Sidekiq::Job

  def perform
    # TODO: Fetch repo from Github
    # Run linters check
    # Make a report
    # Set result to true or false
  end
end
