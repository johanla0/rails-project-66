# frozen_string_literal: true

module RepositoriesHelper
  def commit_url(repository, commit)
    "https://github.com/#{repository.full_name}/commit/#{commit}"
  end
end
