class CartItem < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle_detail
end
