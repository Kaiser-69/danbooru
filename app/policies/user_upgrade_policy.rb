class UserUpgradePolicy < ApplicationPolicy
  def create?
    user.is_member?
  end

  def show?
    record.recipient == user || record.purchaser == user || user.is_owner?
  end
end
