# frozen_string_literal: true

class Repository::CheckMutator
  class << self
    def run!(check)
      check.start!
      git = RepositoryService.shallow_clone!(check.repository)
      if git.blank?
        check.fail!
        return check
      end

      check.commit_hash = git.log.first.sha[0, 7]

      json_data = ApplicationContainer[:linter].build(check)
      if json_data.nil?
        check.fail!
        return check
      end

      check.issues, check.issues_count = Linter::Formatter.build(check, json_data)
      check.finish!
      check.passed = check.issues_count.zero?

      check
    ensure
      repository_directory = check.repository.directory_path
      FileUtils.rm_r repository_directory, force: true
    end
  end
end
