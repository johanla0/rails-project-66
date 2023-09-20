# frozen_string_literal: true

module RepositoriesHelper
  def github_commit_url(repository, commit_id)
    "https://github.com/#{repository.full_name}/commit/#{commit_id}"
  end

  def github_file_url(repository, commit_id, file_path)
    "https://github.com/#{repository.full_name}/tree/#{commit_id}/#{file_path}"
  end
end
