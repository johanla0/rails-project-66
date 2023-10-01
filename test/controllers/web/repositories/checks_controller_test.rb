# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::CheckControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jane)
    @check = repository_checks(:created)
    @repository = repositories(:node)
    sign_in @user
  end

  test '#show' do
    get repository_path(@check.repository, @check)

    assert_response :success
  end

  # rubocop:disable Minitest/MultipleAssertions
  test '#create' do
    checks_count_before = @repository.checks.count
    post repository_checks_path(@repository)

    assert_response :redirect

    @repository.reload

    assert { @repository.checks.count > checks_count_before }

    check = Repository::Check.last

    assert { check.finished? }
    assert { check.issues_count == 3 }
    assert { !check.passed }
  end
  # rubocop:enable Minitest/MultipleAssertions
end
