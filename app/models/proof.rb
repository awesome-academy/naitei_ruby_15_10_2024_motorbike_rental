# frozen_string_literal: true

# The Proof class represents a proof of rental or user action, such as an image or document.
# It is associated with a user and a rental, both of which are optional. The class includes
# an enum for defining the type of storage used for the proof (either 'original' or 'photo').
#
# The class validates that the name, image_path, and storage_type are present before saving.
class Proof < ApplicationRecord
  # A proof belongs to a user. This association is optional, meaning a proof might not
  # be associated with a user.
  belongs_to :user, optional: true

  # A proof belongs to a rental. This association is also optional, meaning a proof might
  # not be associated with a rental.
  belongs_to :rental, optional: true

  # Enum for defining the type of storage for the proof. It can either be 'original' or 'photo'.
  enum storage_type: { original: 0, photo: 1 }

  # Validate that the name, image_path, and storage_type are always present before saving.
  validates :name, :image_path, :storage_type, presence: true
end
