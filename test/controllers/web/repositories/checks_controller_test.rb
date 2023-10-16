# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::CheckControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jane)
    sign_in @user
  end

  test '#show' do
    check = repository_checks(:created)
    get repository_path(check.repository, check)

    assert_response :success
  end

  test '#create' do
    # NOTE: In tests we use ApplicationContainer as a stub in which we return fixed set of data
    # Thus here we check if the number of checks has changed
    repository = repositories(:node)
    checks_count_before = repository.checks.count
    post repository_checks_path(repository)

    assert_response :redirect

    repository.reload

    assert { repository.checks.count > checks_count_before }

    check = repository.checks.last

    assert_enqueued_with(job: CheckRepositoryJob, args: [check.id])
    perform_enqueued_jobs

    check.reload

    assert { check.finished? }
  end
end
