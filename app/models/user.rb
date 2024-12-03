# frozen_string_literal: true

class User < ApplicationRecord
  has_many :rentals, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :proofs, dependent: :destroy
  has_secure_password
  enum role: { guest: 0, user: 1, admin: 2 }
  enum status: { active: 0, inactive: 1, banned: 2 }
  validates :email, presence: true, uniqueness: true
  validates :name, :phone_number, :role, :status, presence: true
end
