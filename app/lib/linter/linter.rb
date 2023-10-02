# frozen_string_literal: true

require 'open3'

module Linter
  class Linter
    attr_reader :check, :json_data

    def initialize(check)
      @check = check
      @json_data = case @check.repository.language.to_sym
                   when :javascript
                     run_javascript_linter
                   when :ruby
                     run_ruby_linter
                   end
    end

    private

    def run_javascript_linter
      repository_directory = @check.repository.decorate.directory_path
      command = "yarn run eslint #{eslint_options(repository_directory).join(' ')} #{repository_directory}"
      stdout, stderr, status = Open3.capture3(command)
      return nil if status.exitstatus > 1 && stderr

      stdout.split("\n")[2]
    end

    def run_ruby_linter
      repository_directory = @check.repository.decorate.directory_path
      command = "bundle exec rubocop #{rubocop_options(repository_directory).join(' ')}"
      Dir.chdir(repository_directory)
      stdout, stderr, status = Open3.capture3(command)
      return nil if status.exitstatus > 1 && stderr

      stdout
    end

    def config_file_lookup(repository_directory, language)
      config_files = case language
                     when :javascript
                       Dir.glob("#{repository_directory}/.eslintrc.*")
                     when :ruby
                       Dir.glob("#{repository_directory}/.rubocop.yml")
                     else
                       []
                     end
      return false if config_files.empty?

      config_files.first
    end

    def eslint_options(repository_directory)
      default_config = '--no-eslintrc'
      config_file_path = config_file_lookup(repository_directory, :javascript)
      options = config_file_path ? "--config #{config_file_path}" : default_config

      ['--format json', options]
    end

    def rubocop_options(repository_directory)
      default_config = "#{Gem::Specification.find_by_name('rubocop').gem_dir}/config/default.yml"
      config_file_path = config_file_lookup(repository_directory, :ruby)
      options = config_file_path ? "--config #{config_file_path}" : "--config #{default_config}"

      [
        '--safe',
        '--ignore-unrecognized-cops',
        '--format json',
        options
      ]
    end
  end
end
