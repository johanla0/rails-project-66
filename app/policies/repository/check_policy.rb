# frozen_string_literal: true

class Repository::CheckPolicy < ApplicationPolicy
  def show?
    user_is_owner?
  end

  def create?
    user_is_owner?
  end

  def user_is_owner?
    user == record.user
  end
end
