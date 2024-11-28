# frozen_string_literal: true

# The CartItem class represents an item in the user's shopping cart. It is associated with
# both a user and a vehicle detail. Each cart item is linked to a specific vehicle detail
# and belongs to a user, forming a relationship between the cart item, user, and vehicle.
#
# This class helps manage the items in a user's cart in an e-commerce or rental application.
class CartItem < ApplicationRecord
  # A cart item belongs to a user, meaning each cart item is associated with a specific user.
  belongs_to :user

  # A cart item belongs to a vehicle detail, meaning each cart item is associated with
  # a specific vehicle's details.
  belongs_to :vehicle_detail
end
