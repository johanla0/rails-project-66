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
        command = "node_modules/eslint/bin/eslint.js #{repository_directory} #{eslint_options.join(' ')}"

        Dir.chdir(Rails.root)
        stdout, stderr, status = Open3.capture3(command)
        return nil if status.exitstatus > 1 && stderr

        stdout.split("\n")[0]
      end

      def run_ruby_linter(repository_directory)
        command = "bundle exec rubocop #{repository_directory} #{rubocop_options.join(' ')}"

        Dir.chdir(repository_directory)
        stdout, stderr, status = Open3.capture3(command)
        return nil if status.exitstatus > 1 && stderr

        stdout
      end

      def eslint_options
        options = "--config #{Dir.glob(Rails.root.join('.eslintrc.*').to_s).first}"

        ['--format json', '--no-eslintrc', options]
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
