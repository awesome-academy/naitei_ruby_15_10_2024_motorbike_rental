# frozen_string_literal: true

# The RentalVehicle class represents a vehicle that is part of a rental transaction.
# It is associated with a rental and a vehicle detail. The class indicates the specific
# vehicle used for a rental and links it to the corresponding rental and vehicle detail.
class RentalVehicle < ApplicationRecord
  # A rental vehicle belongs to a rental. This indicates the rental that the vehicle is part of.
  belongs_to :rental

  # A rental vehicle belongs to a vehicle_detail. This links the rental vehicle to a specific
  # vehicle's details, such as make, model, and specifications.
  belongs_to :vehicle_detail
end
