class User < ApplicationRecord
  USER_PARAMS = %i[name email phone_number password password_confirmation].freeze
  has_many :rentals, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_secure_password
  enum role: { user: 0, admin: 1 }
  enum status: { active: 0, inactive: 1, banned: 2 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :phone_number, :role, :status, presence: true
end
