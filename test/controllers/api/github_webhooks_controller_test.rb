# frozen_string_literal: true

require 'test_helper'

class Api::GithubWebhooksControllerTest < ActionDispatch::IntegrationTest
  test '#checks' do
    post api_checks_path, headers: { 'X-GitHub-Event': 'ping' }

    assert_response :success
    assert { response.parsed_body['message'] == 'pong' }
  end
end
