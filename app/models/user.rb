class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
  USER_PARAMS = %i[name email phone_number password password_confirmation].freeze
  enum role: { customer: 0, admin: 1 }
  has_many :rentals, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, if: :password_required?
  validates :name, :phone_number, presence: true
  after_initialize :set_default_role, if: :new_record?
  def set_default_role
    self.role ||= :customer
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id email name phone_number role]
  end
end
