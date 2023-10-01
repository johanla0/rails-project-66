# frozen_string_literal: true

require 'test_helper'

class Linter::FormatterTest < ActiveSupport::TestCase
  test 'format linter JSON to database stored JSON' do
    check = repository_checks(:created)
    linter = ApplicationContainer[:linter].new(check)
    formatter = Linter::Formatter.new(linter)
    json_result = formatter.json_data

    expected_json = load_fixture('files/json_formatted.json')

    assert_equal JSON.parse(expected_json), JSON.parse(json_result)
  end
end
