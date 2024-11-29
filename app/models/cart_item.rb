class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :model
  validates :quantity,
            presence: true,
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: Rails.application.config_for(:settings).dig(:rental, :rental_limit)
            }
  validates :rental_durations, presence: true, numericality: { greater_than: 0.0 }
  validates :model_id,
            uniqueness: { scope: :user_id }
  before_save :update_total_price
  def update_total_price
    self.total_price = model.price_per_day * quantity * rental_durations
  end
end
