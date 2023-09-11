# frozen_string_literal: true

# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  full_name  :string           not null
#  git_url    :string
#  language   :string
#  name       :string
#  ssh_url    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_repositories_on_full_name  (full_name)
#  index_repositories_on_user_id    (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  test 'valid' do
    repository = repositories(:octokit)

    assert { repository.valid? }
  end
end
