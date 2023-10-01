# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :octokit_client, -> { OctokitClientStub }
    register :linter, -> { LinterStub }
  else
    register :octokit_client, -> { Octokit::Client }
    register :linter, -> { Linter::Linter }
  end
end
