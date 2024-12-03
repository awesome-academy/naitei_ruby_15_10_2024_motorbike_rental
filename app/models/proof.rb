# frozen_string_literal: true

class Proof < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :rental, optional: true
  enum storage_type: { original: 0, photo: 1 }
  validates :name, :image_path, :storage_type, presence: true
end
