class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, Proof
      can :manage, Rental
      can :manage, Model
      can :manage, User
      can :manage, VehicleDetail
    elsif user.customer?
      cannot :manage, Proof
      can :create, Rental
      can :read, Rental, user_id: user.id
      can :cancel, Rental, user_id: user.id, status: "pending"
      can :manage, CartItem
      can :read, Model
      cannot :manage, VehicleDetail
    else
      cannot :manage, Proof
      cannot :manage, Rental
      can :read, Model
    end
  end
end
