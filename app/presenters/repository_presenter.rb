# frozen_string_literal: true

class RepositoryPresenter < SimpleDelegator
  def directory_path
    Rails.root.join("tmp/repositories/#{user.nickname}/#{name}")
  end

  def last_check_status
    checks.any? ? checks.last.passed : I18n.t('no_info')
  end
end
