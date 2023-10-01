# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::CheckControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jane)
    @check = repository_checks(:finished)
    @repository = repositories(:hexletcv)
    sign_in @user
  end

  test '#show' do
    get repository_path(@check.repository, @check)

    assert_response :success
  end

  test '#create' do
    checks_count_before = @repository.checks.count
    post repository_checks_path(@repository)

    assert_response :redirect

    @repository.reload

    assert { @repository.checks.count > checks_count_before }
  end
end
