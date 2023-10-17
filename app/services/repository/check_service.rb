# frozen_string_literal: true

class Repository::CheckService
  class << self
    def shallow_clone!(repository)
      FileUtils.mkdir_p(repository.directory_path)
      Dir.chdir(repository.directory_path)

      begin
        Git.clone(repository.clone_url, nil, depth: 1)
      rescue Git::FailedError => e
        Rails.logger.error(e.message)
        Sentry.capture_exception(e)
        nil
      end
    end
  end
end
