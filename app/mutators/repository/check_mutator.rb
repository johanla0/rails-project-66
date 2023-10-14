# frozen_string_literal: true

class Repository::CheckMutator
  class << self
    def create!(repository)
      check = Repository::Check.create(repository:)
      run!(check)
    end

    private

    def run!(check)
      check.start!
      git = RepositoryService.shallow_clone!(check.repository)
      if git.blank?
        check.fail!
        return check
      end

      check.commit_hash = git.log.first.sha[0, 7]

      linter = ApplicationContainer[:linter].new(check)
      if linter.json_data.nil?
        check.fail!
        return check
      end

      formatter = Linter::Formatter.new(linter)

      check.issues = formatter.json_data
      check.issues_count = formatter.issues_count
      check.finish!
      check.passed = check.issues_count.zero?

      check
    ensure
      repository_directory = check.repository.decorate.directory_path
      FileUtils.rm_r repository_directory, force: true
    end
  end
end
