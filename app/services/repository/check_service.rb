# frozen_string_literal: true

class Repository::CheckService
  class << self
    def create!(repository)
      check = Repository::CheckMutator.create!(repository)
      CheckMailer.with(check:).failed.deliver_later if check.failed?
      CheckMailer.with(check:).with_issues.deliver_later if check.finished? && !check.passed

      check
    end
  end
end
