# frozen_string_literal: true

class RepositoryPresenter < SimpleDelegator
  def last_check_status
    checks.any? ? checks.last.passed : I18n.t('no_info')
  end

  def check_enabled?
    checks.last.blank? || checks.last.failed? || checks.last.finished?
  end

  def check_disabled?
    !check_enabled?
  end
end
