class Model < ApplicationRecord
  belongs_to :brand
  has_many :vehicle_details, dependent: :destroy
  validates :name, presence: true
  scope :empty, -> { none }
  scope :by_brand, ->(brand_id) { where(brand_id: brand_id) if brand_id.present? }
end
