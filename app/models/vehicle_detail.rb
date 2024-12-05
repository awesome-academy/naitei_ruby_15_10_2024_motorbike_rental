class VehicleDetail < ApplicationRecord
  belongs_to :model
  has_many :rental_vehicles, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  enum vehicle_type: { scooter: 0, manual: 1, moto: 2 }
  enum engine_capacity: { under_50cc: 0, from_50_to_100cc: 1, from_100_to_175cc: 2, over_175cc: 3, unknown: 4 }
  validates :number, :vehicle_type, :engine_capacity, :price_per_day, :available, presence: true
  validates :color, presence: true
end
