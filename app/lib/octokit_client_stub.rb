# frozen_string_literal: true

class OctokitClientStub
  def initialize(*); end

  def repos
    fixture = load_fixture('files/repos.json')
    JSON.parse(fixture, symbolize_names: true)
  end

  private

  def load_fixture(filename)
    File.read("#{Rails.root}/test/fixtures/#{filename}")
  end
end
