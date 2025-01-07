class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :model

  validates :start_datetime, presence: true
  validates :end_datetime, presence: true
  validates :rental_durations, presence: true, numericality: { greater_than: 0.0 }
  validates :quantity,
            presence: true,
            numericality: {
              greater_than: -1,
              less_than_or_equal_to: :available_quantity
            }
  validates :model_id,
            uniqueness: { scope: :user_id }

  before_save :update_total_price
  before_validation :set_available_quantity

  def update_total_price
    self.total_price = model.price_per_day * quantity * rental_durations
  end

  private

  def set_available_quantity
    @available_quantity = model.vehicle_free_count(start_datetime, end_datetime)
  end

  def available_quantity
    @available_quantity || model.vehicle_free_count(start_datetime, end_datetime)
  end
end
