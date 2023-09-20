# frozen_string_literal: true

module Linter
  class Formatter
    attr_reader :linter, :json_data, :issues_count

    def initialize(linter)
      @linter = linter
      parsed_raw_data = JSON.parse(@linter.json_data, symbolize_names: true)

      case @linter.check.repository.language
      when :javascript
        @issues_count = count_issues_eslint(parsed_raw_data)
        formatted_data = format_eslint(parsed_raw_data)
        @json_data = JSON.generate(formatted_data)
      when :ruby
        @issues_count = count_issues_rubocop(parsed_raw_data)
        formatted_data = format_rubocop(parsed_raw_data)
        @json_data = JSON.generate(formatted_data)
      end
    end

    private

    def format_eslint(data)
      return {} if @issues_count.zero?

      repository_directory = @linter.check.repository.decorate.directory_path
      data.map do |file|
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

    def format_rubocop(data)
      return {} if @issues_count.zero?

      repository_directory = @linter.check.repository.decorate.directory_path
      data[:files].map do |file|
        issues = file[:offenses].map do |offense|
          {
            message: offense[:message],
            name: offense[:cop_name],
            line: offense[:location][:line],
            column: offense[:location][:column]
          }
        end
        { path: file[:path].delete_prefix("#{repository_directory}/"), issues: }
      end
    end

    def count_issues_eslint(data)
      data.reduce(0) { |sum, file| sum + file[:messages].count }
    end

    def count_issues_rubocop(data)
      data[:summary][:offense_count]
    end
  end
end
