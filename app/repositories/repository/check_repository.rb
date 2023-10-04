# frozen_string_literal: true

module Repository::CheckRepository
  extend ActiveSupport::Concern

  included do
    scope :order_by_created_at, -> { order(created_at: :desc) }
  end
end
