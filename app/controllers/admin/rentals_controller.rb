class Admin::RentalsController < ApplicationController
  include Pagy::Backend
  before_action :authorize_admin
  before_action :set_rental, only: %i[show approve reject]

  def index
    @rentals = Rental.filter_by(params).order(created_at: :desc)

    @pagy, @rentals = pagy(@rentals)
  end

  def show
    @rental_vehicles = @rental.rental_vehicles.includes(:vehicle_detail)
    @vehicle_details = @rental_vehicles.map(&:vehicle_detail)
  end

  def approve
    if @rental.pending?
      @rental.update(status: :approved)
      flash[:success] = t("controller.rentals.approve.success")
    else
      flash[:error] = t("controller.rentals.approve.error")
    end
    redirect_to admin_rentals_path
  end

  def reject
    if @rental.pending? && params[:decline_reason].present?
      @rental.update(status: :rejected, decline_reason: params[:decline_reason])
      flash[:success] = t("controller.rentals.reject.success")
    else
      flash[:error] = t("controller.rentals.reject.error")
    end
    redirect_to admin_rentals_path
  end

  private

  def set_rental
    @rental = Rental.find_by(id: params[:id])
    return unless @rental.nil?

    flash[:error] = t("controller.rentals.not_found")
    redirect_to admin_rentals_path
  end

  def authorize_admin
    return if current_user.admin?

    flash[:error] = t("controller.rentals.unauthorized")
    redirect_to root_path
  end
end
