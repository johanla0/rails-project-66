# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jane)
    @repository = repositories(:node)
    sign_in @user
  end

  test '#index' do
    get repositories_path

    assert_response :success
  end

  test '#new' do
    get new_repository_path

    assert_response :success
  end

  test '#show' do
    get repository_path(@repository)

    assert_response :success
  end

  test '#create' do
    response = load_fixture('files/repo_javascript.json')

    uri_template = Addressable::Template.new 'https://api.github.com/repos/{user}/{repo}'
    stub_request(:get, uri_template)
      .to_return(
        status: 200,
        body: response,
        headers: { content_type: 'application/json' }
      )

    attrs = {
      github_id: 307_194_079
    }

    post repositories_path, params: { repository: attrs }

    repository = Repository.find_by attrs

    assert { repository.present? }
    assert_redirected_to repository_path(repository)
  end

  test '#destroy' do
    delete repository_path(@repository)

    assert_response :redirect
    repository = Repository.find_by id: @repository.id

    assert { repository.blank? }
  end
end
