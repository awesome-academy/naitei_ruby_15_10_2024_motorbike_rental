class Rental < ApplicationRecord
  belongs_to :user
  has_many :rental_vehicles, dependent: :destroy
  has_many :proofs, dependent: :destroy
  enum status: { pending: 0, approved: 1, rejected: 2, canceled: 3, renting: 4, returned: 5 }
  validates :name, :phone_number, :delivery_location, :start_datetime, :end_datetime, :status, :total_price,
            presence: true
  validates :decline_reason, presence: true, if: :rejected?
  scope :by_user, ->(user_id) { where(user_id: user_id).order(created_at: :desc) if user_id.present? }
  scope :overdue, lambda {
    where("rentals.status != ? AND end_datetime < ?", statuses[:returned], Time.current)
  }

  def self.ransackable_attributes(_auth_object = nil)
    %w[user_id name email phone_number start_datetime end_datetime status overdue_eq]
  end

  def self.ransackable_scopes(_auth_object = nil)
    %w[overdue]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[proofs rental_vehicles user]
  end

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
