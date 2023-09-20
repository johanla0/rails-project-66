# frozen_string_literal: true

require 'open3'

module Linter
  class Linter
    attr_reader :check, :json_data

    def initialize(check)
      @check = check

      # TODO: Distinguish which linter to run
      @json_data = run_javascript_linter
    end

    private

    def run_javascript_linter
      repository_directory = @check.repository.decorate.directory_path
      command = "yarn run eslint #{eslint_options.join(' ')} #{repository_directory}"
      stdout, stderr, status = Open3.capture3(command)
      return nil if status.exitstatus.positive? && stderr

      stdout.split("\n")[2]
    end

    # TODO: Add ruby linter
    def run_ruby_linter; end

    def config_file_lookup(language)
      repository_directory = @check.repository.decorate.directory_path
      config_files = case language
                     when :javascript
                       Dir.glob("#{repository_directory}/.eslintrc.*")
                     when :ruby
                       Dir.glob("#{repository_directory}/.rubocop.yml")
                     else
                       return false
                     end
      return false if config_files.empty?

      "#{repository_directory}/#{config_files.first}"
    end

    def eslint_options
      default_config = '--no-eslintrc'
      config_file = config_file_lookup(:javascript)
      options = config_file ? "--config #{config_file}" : default_config

      ['--format json', options]
    end

    def rubocop_options
      default_config = "#{Gem::Specification.find_by_name('rubocop').gem_dir}/config/default.yml"
      config_file = config_file_lookup(:ruby)
      options = config_file ? "--config #{config_file}" : "--config #{default_config}"

      [
        '--safe',
        '--ignore-unrecognized-cops',
        '--format json',
        options
      ]
    end
  end
end
