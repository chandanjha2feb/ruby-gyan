class TagPolicy < ApplicationPolicy
    def index?
      @user.has_role?(:admin, @user)
    end
    
    def destroy?
      @user.has_role?(:admin, @user)
    end
end