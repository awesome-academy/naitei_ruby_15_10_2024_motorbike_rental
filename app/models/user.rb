# frozen_string_literal: true

# The User class represents a user of the application.
# It manages authentication, roles, and associations with rentals, cart items, and proofs.
# The class uses `has_secure_password` for secure password handling, and defines various
# roles and statuses that a user can have in the system.
class User < ApplicationRecord
  # Enable secure password handling for the user. This provides methods to set and authenticate
  # against a BCrypt password. It adds functionality like `password` and `password_confirmation`.
  has_secure_password

  # A user can have many rentals. If a user is deleted, all associated rentals will also be deleted.
  has_many :rentals, dependent: :destroy

  # A user can have many cart items. If a user is deleted, all associated cart items will also be deleted.
  has_many :cart_items, dependent: :destroy

  # A user can have many proofs. If a user is deleted, all associated proofs will also be deleted.
  has_many :proofs, dependent: :destroy

  # Define the available roles for the user. These roles help manage user access and permissions.
  enum role: { guest: 0, user: 1, admin: 2 }

  # Define the available statuses for the user. This helps track the user's account status.
  enum status: { active: 0, inactive: 1, banned: 2 }

  # Validate that the email is present and unique for each user.
  validates :email, presence: true, uniqueness: true

  # Validate that the role and status are always set for each user.
  validates :role, :status, presence: true
end
