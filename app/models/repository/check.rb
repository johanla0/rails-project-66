# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id            :integer          not null, primary key
#  commit        :string
#  issue_count   :integer          default(0)
#  issues        :json
#  result        :boolean          default(FALSE)
#  state         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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

  aasm column: 'state' do
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
end
