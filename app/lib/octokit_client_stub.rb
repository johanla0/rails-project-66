# frozen_string_literal: true

class OctokitClientStub
  def initialize(*); end

  def repos
    # fixture = load_fixture('files/repos.json')
    fixture = load_fixture('files/user_repositories.json')
    JSON.parse(fixture, symbolize_names: true)
  end

  def repo(_github_id)
    fixture = load_fixture('files/node.json')
    JSON.parse(fixture, symbolize_names: true)
  end

  private

  def load_fixture(filename)
    File.read(Rails.root.join("test/fixtures/#{filename}").to_s)
  end
end
