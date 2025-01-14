class Rental < ApplicationRecord
  belongs_to :user
  has_many :rental_vehicles, dependent: :destroy
  has_many :proofs, dependent: :destroy
  enum status: { pending: 0, approved: 1, rejected: 2, canceled: 3, renting: 4, returned: 5 }
  validates :name, :phone_number, :delivery_location, :start_datetime, :end_datetime, :status, :total_price,
            presence: true
  validates :decline_reason, presence: true, if: :rejected?
  scope :by_user, ->(user_id) { where(user_id: user_id).order(created_at: :desc) if user_id.present? }
  scope :search_by_name, ->(name) { where("rentals.name LIKE ?", "%#{name}%") if name.present? }
  scope :search_by_email, lambda { |email|
    if email.present?
      where("users.email LIKE ?", "%#{email}%")
        .joins(:user)
    end
  }
  scope :search_by_phone, ->(phone) { where("rentals.phone_number LIKE ?", "%#{phone}%") if phone.present? }
  scope :search_by_date_range, lambda { |start_date, end_date|
    where("start_datetime >= ? AND end_datetime <= ?", start_date, end_date) if start_date.present? && end_date.present?
  }
  scope :search_by_status, ->(status) { where(status: status) if status.present? }
  scope :overdue, lambda { |overdue|
    where("rentals.status != ? AND end_datetime < ?", :returned, Time.current) if overdue.present?
  }
  scope :filter_by, lambda { |params|
    by_user(params[:user_id])
      .search_by_name(params[:search_name])
      .search_by_phone(params[:search_phone])
      .search_by_email(params[:search_email])
      .search_by_date_range(params[:start_datetime], params[:end_datetime])
      .search_by_status(params[:status])
      .overdue(params[:overdue])
  }
  def overdue?
    end_datetime < Time.current && status != "returned"
  end

  def cancellable?
    pending? && !approved? && !rejected?
  end

  def can_rent?
    approved? && proofs.exists?
  end

  def status_name
    I18n.t("models.rental.statuses.#{status}")
  end
end
