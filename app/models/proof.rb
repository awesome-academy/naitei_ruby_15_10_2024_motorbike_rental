class Proof < ApplicationRecord
  belongs_to :user
  belongs_to :rental
  has_one_attached :image
  enum storage_type: { original: 0, copy: 1 }
  validates :name, :image, :storage_type, presence: true
end
