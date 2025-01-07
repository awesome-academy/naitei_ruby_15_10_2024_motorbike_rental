class VehicleDetail < ApplicationRecord
  belongs_to :model
  has_many :rental_vehicles, dependent: :destroy
  delegate :price_per_day, to: :model
  has_one_attached :image do |attachable|
    attachable.variant :thumb,
                       resize_to_limit: Rails.application.config_for(:settings).dig(:image_upload, :resize_to_limit)
  end

  validates :number, presence: true, uniqueness: true
  validates :color, presence: true
  validates :model_id,
            presence: { message: I18n.t("activerecord.errors.models.vehicle_detail.attributes.model_id.blank") }

  validates :image,
            content_type: Rails.application.config_for(:settings).dig(:image_upload, :allowed_types),
            size: { less_than: Rails.application.config_for(:settings).dig(:image_upload, :max_size_mb).megabytes },
            if: :image_attached?
  scope :ordered_by_newest, -> { order(created_at: :desc) }
  scope :available, -> { where(available: true) }
  scope :free_in_time_range, lambda { |start_datetime, end_datetime|
    available.where.not(id: RentalVehicle.joins(:rental).where(
      "rentals.start_datetime < ? AND rentals.end_datetime > ?",
      end_datetime, start_datetime
    ).select(:vehicle_detail_id))
  }

  PERMITTED_PARAMS = %i[
    model_id
    number
    color
    available
    image
  ].freeze

  private

  def image_attached?
    image.attached?
  end
end
