class User < ApplicationRecord
  USER_PARAMS = %i[name email phone_number password password_confirmation].freeze
  has_many :rentals, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_secure_password
  enum role: { user: 0, admin: 1 }
  enum status: { active: 0, inactive: 1, banned: 2 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :phone_number, :role, :status, presence: true
  validates :role, inclusion: { in: roles.keys }
  validates :status, inclusion: { in: statuses.keys }
  def generate_remember_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Digest::SHA256.hexdigest(generate_remember_token)
    save(validate: false)
  end

  def authenticated?(remember_token)
    return false if self.remember_token.blank?

    Digest::SHA256.hexdigest(remember_token) == self.remember_token
  end

  def forget
    update(remember_token: nil)
  end

  def self.authenticate(login, password)
    user = find_by("email = ? OR phone_number = ?", login, login)
    user&.authenticate(password) ? user : nil
  end
end
