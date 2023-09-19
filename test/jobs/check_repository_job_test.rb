# frozen_string_literal: true

require 'test_helper'

class CheckRepositoryJobTest < ActionDispatch::IntegrationTest
  test '#perform javascript' do
    repository = repositories(:node)
    CheckRepositoryJob.new.perform(repository.id)

    check = Repository::Check.last
    assert { check.finished? }
    assert { check.issues_count.zero? }
    assert { check.passed }
  end

  test '#perform ruby' do
    repository = repositories(:hexletcv)
    CheckRepositoryJob.new.perform(repository.id)

    check = Repository::Check.last
    assert { check.finished? }
    assert { check.issues_count.zero? }
    assert { check.passed }
  end
end
