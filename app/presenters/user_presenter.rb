# frozen_string_literal: true

class UserPresenter < SimpleDelegator
  def directory_path
    Rails.root.join("tmp/repositories/#{nickname}")
  end
end
