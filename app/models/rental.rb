class Rental < ApplicationRecord
  has_many :rental_vehicles, dependent: :destroy
  has_many :proofs, dependent: :destroy
  enum status: { pending: 0, approved: 1, rejected: 2, canceled: 3, renting: 4, returned: 5 }
  validates :name, :phone_number, :delivery_location, :start_datetime, :end_datetime, :status, :total_price,
            presence: true
  validates :decline_reason, presence: true, if: :rejected?
  scope :search_by_name, ->(name) { where("name LIKE ?", "%#{name}%") if name.present? }
  scope :search_by_phone, ->(phone) { where("phone_number LIKE ?", "%#{phone}%") if phone.present? }
  scope :search_by_date_range, lambda { |start_date, end_date|
    where("start_datetime >= ? AND end_datetime <= ?", start_date, end_date) if start_date.present? && end_date.present?
  }
  scope :filter_by, lambda { |params|
    search_by_name(params[:search_name])
      .search_by_phone(params[:search_phone])
      .search_by_date_range(params[:start_datetime], params[:end_datetime])
  }
  scope :by_user, ->(user_id) { where(user_id: user_id).order(created_at: :desc) }
  def cancellable?
    pending? && !approved? && !rejected?
  end

  def status_name
    I18n.t("models.rental.statuses.#{status}")
  end
end
