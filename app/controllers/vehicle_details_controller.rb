class VehicleDetailsController < ApplicationController
  before_action :init_new, only: %i[new create]
  def new
    @vehicle_detail = VehicleDetail.new
  end

  def create
    @vehicle_detail = VehicleDetail.new(vehicle_detail_params)
    if @vehicle_detail.save
      flash[:success] = t "controller.vehicle.create.success"
      redirect_to vehicle_details_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def models
    @models = Model.by_brand(params[:brand_id])
    render json: @models
  end

  private

  def vehicle_detail_params
    params.require(:vehicle_detail).permit(VehicleDetail::PERMITTED_PARAMS)
  end

  def init_new
    @brands = Brand.order(:name)
    @models = Model.empty
  end
end
