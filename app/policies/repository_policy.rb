# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def show
    record.user == user
  end
end
