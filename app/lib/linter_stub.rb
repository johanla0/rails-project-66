# frozen_string_literal: true

class LinterStub
  class << self
    def build(*)
      load_fixture('files/json_result_success.json')
      # load_fixture('files/json_result.json')
    end

    private

    def load_fixture(filename)
      File.read(Rails.root.join("test/fixtures/#{filename}").to_s)
    end
  end
end
