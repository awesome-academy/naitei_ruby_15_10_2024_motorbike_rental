class Model < ApplicationRecord
  belongs_to :brand
  has_many :vehicle_details, dependent: :destroy
  enum vehicle_type: { scooter: 0, manual: 1, moto: 2 }
  enum engine_capacity: { under_50cc: 0, from_50_to_100cc: 1, from_100_to_175cc: 2, over_175cc: 3, unknown: 4 }

  validates :name, presence: true
  validates :price_per_day, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vehicle_type, presence: true
  validates :engine_capacity, presence: true

  scope :empty, -> { none }
  scope :by_brand, ->(brand_id) { where(brand_id: brand_id) if brand_id.present? }
  scope :ordered_by_vehicle_count, lambda {
    left_joins(:vehicle_details)
      .group("models.id")
      .order(Arel.sql("COUNT(CASE WHEN vehicle_details.available = true THEN 1 END) DESC"))
  }
  scope :available, -> { joins(:vehicle_details).where(vehicle_details: { available: true }) }

  def vehicle_details_count
    vehicle_details.available.count
  end
end
