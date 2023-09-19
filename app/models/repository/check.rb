# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id            :integer          not null, primary key
#  aasm_state    :string
#  issues        :json
#  issues_count  :integer          default(0)
#  passed        :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  commit_id     :string
#  repository_id :integer          not null
#
# Indexes
#
#  index_repository_checks_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  repository_id  (repository_id => repositories.id)
#
class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  aasm do
    state :created, initial: true
    state :in_process, :failed, :finished

    event :start do
      transitions from: :created, to: :in_process
    end

    event :fail do
      transitions from: :in_process, to: :failed
    end

    event :finish do
      transitions from: :in_process, to: :finished
    end
  end

  def with_issues?
    issues_count.positive?
  end
end
