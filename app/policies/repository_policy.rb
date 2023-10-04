# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def show?
    user_is_owner?
  end

  def destroy?
    user_is_owner?
  end
end
