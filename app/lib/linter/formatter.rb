# frozen_string_literal: true

module Linter
  class Formatter
    attr_reader :linter, :parsed_data, :json_data, :issues_count

    def initialize(linter)
      @linter = linter
      @parsed_data = JSON.parse(linter.json_data, symbolize_names: true)

      @json_data = JSON.generate(format_eslint_json)
      @issues_count = count_issues_eslint
    end

    private

    def format_eslint_json
      repository_directory = @linter.check.repository.decorate.directory_path

      @parsed_data.map do |file|
        issues = file[:messages].map do |message|
          {
            message: message[:message],
            name: message[:ruleId],
            line: message[:line],
            column: message[:column]
          }
        end
        { path: file[:filePath].delete_prefix("#{repository_directory}/"), issues: }
      end
    end

    def count_issues_eslint
      @parsed_data.reduce(0) { |sum, file| sum + file[:messages].count }
    end
  end
end
