# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @repository = repositories(:octokit)
  end

  test '#index unauthorized' do
    get repositories_path
    assert_response :redirect
  end

  test '#index' do
    sign_in @user

    get repositories_path
    assert_response :success
  end

  test '#new' do
    sign_in @user

    get new_repository_path
    assert_response :success
  end

  test '#show' do
    sign_in @user

    get repository_path(@repository)
    assert_response :success
  end

  test '#create' do
    sign_in @user

    attrs = {
      name: 'hexlet-cv',
      full_name: 'hexlet/hexlet-cv',
      language: 'Ruby',
      git_url: 'https://github.com/Hexlet/hexlet-cv',
      ssh_url: 'git@github.com:Hexlet/hexlet-cv.git'
    }

    post repositories_path, params: { repository: attrs }

    assert_response :redirect

    repository = Repository.find_by attrs

    assert { repository.present? }
  end

  test '#destroy' do
    sign_in @user

    delete repository_path(@repository)

    assert_response :redirect

    repository = Repository.find @repository.id

    assert { repository.blank? }
  end
end
