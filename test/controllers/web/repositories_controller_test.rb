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

  # rubocop:disable Minitest/MultipleAssertions: Test case has too many assertions
  test '#create' do
    attrs = {
      github_id: 307_194_079
    }

    post repositories_path, params: { repository: attrs }

    repository = Repository.find_by attrs

    assert_enqueued_with(job: UpdateRepositoryJob, args: [repository.id])
    perform_enqueued_jobs

    repository.reload

    assert { repository.present? }
    assert { repository.name.present? }
    assert_redirected_to repository_path(repository)
  end
  # rubocop:enable Minitest/MultipleAssertions: Test case has too many assertions

  test '#destroy' do
    delete repository_path(@repository)

    assert_response :redirect
    repository = Repository.find_by id: @repository.id

    assert { repository.blank? }
  end
end
