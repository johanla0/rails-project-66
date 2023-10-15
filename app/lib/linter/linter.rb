# frozen_string_literal: true

require 'open3'

module Linter
  class Linter
    class << self
      def build(check)
        repository_directory = check.repository.directory_path

        case check.repository.language.to_sym
        when :javascript
          run_javascript_linter(repository_directory)
        when :ruby
          run_ruby_linter(repository_directory)
        end
      end

      private

      def run_javascript_linter(repository_directory)
        command = "yarn run eslint #{eslint_options.join(' ')} #{repository_directory}"
        stdout, stderr, status = Open3.capture3(command)
        return nil if status.exitstatus > 1 && stderr

        stdout.split("\n")[2]
      end

      def run_ruby_linter(repository_directory)
        command = "bundle exec rubocop #{rubocop_options.join(' ')}"
        Dir.chdir(repository_directory)
        stdout, stderr, status = Open3.capture3(command)
        return nil if status.exitstatus > 1 && stderr

        stdout
      end

      def eslint_options
        options = "--config #{Dir.glob(Rails.root.join('.eslintrc.*').to_s).first}"

        ['--format json', options]
      end

      def rubocop_options
        options = "--config #{Dir.glob(Rails.root.join('.rubocop.yml').to_s).first}"

        [
          '--safe',
          '--ignore-unrecognized-cops',
          '--format json',
          options
        ]
      end
    end
  end
end
