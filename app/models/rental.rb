# frozen_string_literal: true

# The Rental class represents a rental transaction in the system.
# It is associated with a user, and it can have multiple rental vehicles and proofs.
# The class includes an enum for defining the status of the rental (e.g., pending, approved, etc.),
# and it validates that the start and end times, as well as the status, are present before saving.
class Rental < ApplicationRecord
  # A rental belongs to a user. This indicates the user who created or owns the rental.
  belongs_to :user

  # A rental has many rental_vehicles. If a rental is destroyed, all associated rental_vehicles
  # are also destroyed.
  has_many :rental_vehicles, dependent: :destroy

  # A rental has many proofs. If a rental is destroyed, all associated proofs are also destroyed.
  has_many :proofs, dependent: :destroy

  # Enum for defining the rental's status. The available statuses are:
  # - pending: The rental has been created but is not yet processed.
  # - approved: The rental has been approved.
  # - rejected: The rental was rejected.
  # - canceled: The rental was canceled.
  # - renting: The rental is currently active.
  # - returned: The rental has been completed and the vehicle has been returned.
  enum status: { pending: 0, approved: 1, rejected: 2, canceled: 3, renting: 4, returned: 5 }

  # Validate that the start_datetime, end_datetime, and status are always present before saving.
  validates :start_datetime, :end_datetime, :status, presence: true
end
