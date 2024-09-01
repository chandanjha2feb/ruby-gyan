class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def show?
    @record.published && @record.approved || 
    @user.present? && @user.has_role?(:admin, @user) || 
    @user.present? && @record.user_id == @user.id || 
    @user.present? && @record.bought(@user)
  end

  def edit?
    @record.user == @user
  end

  def analytics?
    @record.user == @user
  end

  def create?
    @user.has_role?(:teacher, @user) || @record.user == @user
  end

  def destroy?
    @record.user == @user && @record.enrollments.none?
  end

  def new?
    @user.has_role?(:teacher, @user)
  end

  def update?
    @record.user == @user
  end

  def approve?
    @user.has_role?(:admin, @user)
  end

  def owner?
    @record.user == @user
  end

  def admin_or_owner?
    @user.has_role?(:admin) || @record.user == @user
  end
end
