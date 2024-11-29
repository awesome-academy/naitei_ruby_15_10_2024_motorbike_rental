# frozen_string_literal: true

class Rental < ApplicationRecord
  has_many :rental_vehicles, dependent: :destroy
  has_many :proofs, dependent: :destroy
  enum status: { pending: 0, approved: 1, rejected: 2, canceled: 3, renting: 4, returned: 5 }
  validates :name, :phone_number, :delivery_location, :start_datetime, :end_datetime, :status, :total_price,
            presence: true
end
