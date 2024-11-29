class Model < ApplicationRecord
  belongs_to :brand
  has_many :vehicle_details, dependent: :destroy
  validates :name, presence: true
end
