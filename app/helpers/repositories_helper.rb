# frozen_string_literal: true

module RepositoriesHelper
  def github_commit_url(repository, commit_hash)
    "https://github.com/#{repository.full_name}/commit/#{commit_hash}"
  end

  def github_file_url(repository, commit_hash, file_path)
    "https://github.com/#{repository.full_name}/tree/#{commit_hash}/#{file_path}"
  end
end
