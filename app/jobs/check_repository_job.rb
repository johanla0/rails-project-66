# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    check = Repository::Check.find check_id
    return if check.blank?

    run!(check)
    CheckMailer.with(check:).failed.deliver_later if check.failed?
    CheckMailer.with(check:).with_issues.deliver_later if check.finished? && !check.passed
  end

  private

  def run!(check)
    check.start!
    git = ApplicationContainer[:check_service].shallow_clone!(check.repository)
    if git.blank?
      check.fail!
      check.save!
      return
    end

    check.commit_hash = git.log.first.sha[0, 7]

    json_data = ApplicationContainer[:linter].build(check)
    if json_data.nil?
      check.fail!
      check.save!
      return
    end

    check.issues, check.issues_count = Linter::Formatter.build(check, json_data)
    check.finish!
    check.passed = check.issues_count.zero?
    check.save!
  ensure
    repository_directory = check.repository.directory_path
    FileUtils.rm_r repository_directory, force: true
  end
end
