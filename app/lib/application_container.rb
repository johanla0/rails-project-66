# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :octokit_client, -> { OctokitClientStub }
    register :linter, -> { LinterStub }
    register :check_service, -> { CheckServiceStub }
  else
    register :octokit_client, -> { Octokit::Client }
    register :linter, -> { Linter::Linter }
    register :check_service, -> { Repository::CheckService }
  end
end
