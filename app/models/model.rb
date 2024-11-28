# frozen_string_literal: true

# The Model class represents a model of a vehicle. It is associated with a specific brand
# and can have many associated vehicle details. If a model is destroyed, its associated
# vehicle details are also destroyed.
#
# The class validates that the name of the model is always present before saving to the database.
class Model < ApplicationRecord
  # A model belongs to a brand, meaning each model is associated with a specific brand.
  belongs_to :brand

  # A model can have many vehicle details. If a model is deleted, its associated vehicle details
  # are also deleted.
  has_many :vehicle_details, dependent: :destroy

  # Validate that the name of the model is present before it can be saved to the database.
  validates :name, presence: true
end
