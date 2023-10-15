# frozen_string_literal: true

class Repository::CheckService
  class << self
    def run!(check)
      check = Repository::CheckMutator.run!(check)
      CheckMailer.with(check:).failed.deliver_later if check.failed?
      CheckMailer.with(check:).with_issues.deliver_later if check.finished? && !check.passed

      check
    end
  end
end
