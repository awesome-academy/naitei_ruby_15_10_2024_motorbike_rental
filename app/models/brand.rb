# frozen_string_literal: true

# The Brand class represents a brand in the application. It inherits from ApplicationRecord,
# meaning it is a model backed by the database. A brand can have many associated models,
# and if a brand is destroyed, its associated models are also destroyed.
#
# Validations are applied to ensure that a brand always has a name.
class Brand < ApplicationRecord
  # A brand can have many models, and if a brand is deleted, its models will also be deleted.
  has_many :models, dependent: :destroy

  # Validate that the name of the brand is present before it can be saved to the database.
  validates :name, presence: true
end
