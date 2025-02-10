class Api::V1::VehicleDetailsController < Api::V1::BaseController
  before_action :set_vehicle_detail, only: %i[show update destroy]
  load_and_authorize_resource
  skip_before_action :verify_authenticity_token
  def index
    @pagy, @vehicle_details = pagy(
      VehicleDetail.includes(model: :brand).ordered_by_newest
    )
    render json: @vehicle_details
  end

  def create
    @vehicle_detail = VehicleDetail.new(vehicle_detail_params)
    if @vehicle_detail.save
      render json: @vehicle_detail, status: :created
    else
      render json: { errors: @vehicle_detail.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @vehicle_detail.update(vehicle_detail_params)
      render json: @vehicle_detail
    else
      render json: { errors: @vehicle_detail.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @vehicle_detail.destroy
      render json: { message: I18n.t("controller.vehicle_detail.destroy.success") }
    else
      render json: { error: I18n.t("controller.vehicle_detail.destroy.failure") }, status: :unprocessable_entity
    end
  end

  private

  def vehicle_detail_params
    params.require(:vehicle_detail).permit(VehicleDetail::PERMITTED_PARAMS)
  end

  def set_vehicle_detail
    @vehicle_detail = VehicleDetail.find_by(id: params[:id])
    return if @vehicle_detail

    render json: { error: I18n.t("controller.vehicle_detail.not_found") }, status: :not_found
  end
end
