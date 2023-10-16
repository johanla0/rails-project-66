# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    queue_adapter.perform_enqueued_jobs = true
    queue_adapter.perform_enqueued_at_jobs = true

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
    attrs = {
      github_id: 2
    }

    post repositories_path, params: { repository: attrs }

    repository = Repository.find_by attrs
    repository.reload

    assert { repository.present? }
    assert { repository.language.present? }
    assert_redirected_to repository_path(repository)
  end

  test '#destroy' do
    delete repository_path(@repository)

    assert_response :redirect
    repository = Repository.find_by id: @repository.id

    assert { repository.blank? }
  end
end
