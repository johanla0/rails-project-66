# frozen_string_literal: true

class LinterStub
  def initialize(*); end

  def check
    Repository::Check.find ActiveRecord::FixtureSet.identify(:created)
  end

  def json_data
    load_fixture('files/json_result.json')
  end

  private

  def load_fixture(filename)
    File.read(Rails.root.join("test/fixtures/#{filename}").to_s)
  end
end
