class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    @user.has_role?(:admin, @user)
  end

  def update?
    @user.has_role?(:admin, @user)
  end
end
