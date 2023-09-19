# frozen_string_literal: true

class RepositoryPresenter < SimpleDelegator
  def directory_path
    Rails.root.join("tmp/repositories/#{user.nickname}/#{name}")
  end
end
