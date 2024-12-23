class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle_detail
  validates :quantity,
            presence: true,
            numericality: {
              greater_than: 0,
              less_than_or_equal_to: Rails.application.config_for(:settings).dig(:rental, :rental_limit)
            }
  validates :vehicle_detail_id,
            uniqueness: { scope: :user_id }
end
