class User::RentalsController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_rental, only: %i[show cancel]
  load_and_authorize_resource
  def index
    @rentals = Rental.by_user(current_user.id).filter_by(params).order(created_at: :desc)
    @pagy, @rentals = pagy(@rentals)
  end

  def create
    @rental = initialize_rental
    start_datetime = DateTime.parse(rental_params[:start_datetime])
    end_datetime = DateTime.parse(rental_params[:end_datetime])

    ActiveRecord::Base.transaction do
      if @rental.save
        process_cart_items(start_datetime, end_datetime)
        clear_cart
        redirect_to user_rentals_path, notice: t("controller.rentals.create.success")
      else
        flash[:alert] = t("controller.rentals.create.failure")
        render :new
      end
    rescue StandardError => e
      flash[:alert] = t("controller.rentals.create.error", message: e.message)
      render :new
    end
  end

  def show
    @rental_vehicles = @rental.rental_vehicles.includes(:vehicle_detail)
    @vehicle_details = @rental_vehicles.map(&:vehicle_detail)
  end

  def cancel
    if @rental.cancellable?
      @rental.update(status: :canceled)
      flash[:success] = t("controller.rentals.cancel.success")
    else
      flash[:error] = t("controller.rentals.cancel.error")
    end
    redirect_to user_rental_path(@rental)
  end

  private

  def set_rental
    @rental = Rental.find_by(id: params[:id])
    return unless @rental.nil?

    flash[:error] = t("controller.rentals.not_found")
    redirect_to user_rentals_path
  end

  def rental_params
    params.require(:rental).permit(:name, :phone_number, :delivery_location, :start_datetime,
                                   :end_datetime, :total_price)
  end

  def initialize_rental
    rental = Rental.new(rental_params)
    rental.user_id = current_user.id
    rental.status = Rental.statuses[:pending]
    rental
  end

  def process_cart_items(start_datetime, end_datetime)
    cart_items = current_user.cart_items.includes(:model)
    cart_items.each do |cart_item|
      ensure_vehicle_availability(cart_item, start_datetime, end_datetime)
      assign_vehicle_details_to_rental(cart_item, start_datetime, end_datetime)
    end
  end

  def ensure_vehicle_availability(cart_item, start_datetime, end_datetime)
    available_count = cart_item.model.vehicle_free_count(start_datetime, end_datetime)
    return unless available_count < cart_item.quantity

    flash[:alert] = t("controller.rentals.create.not_enough_vehicles", model_name: cart_item.model.name)
    raise ActiveRecord::Rollback
  end

  def assign_vehicle_details_to_rental(cart_item, start_datetime, end_datetime)
    vehicle_details = VehicleDetail.free_in_time_range_for_model(start_datetime, end_datetime, cart_item.model_id,
                                                                 cart_item.quantity)
    vehicle_details.each do |vehicle_detail|
      @rental.rental_vehicles.create!(vehicle_detail_id: vehicle_detail.id)
    end
  end
end
