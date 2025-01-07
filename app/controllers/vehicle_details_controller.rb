class VehicleDetailsController < ApplicationController
  before_action :init_new, only: %i[new create edit]
  before_action :load_vehicle_detail, only: %i[destroy update edit]
  before_action :authorize_admin

  def index
    @pagy, @vehicle_details = pagy(
      VehicleDetail.includes(model: :brand).ordered_by_newest
    )
  end

  def new
    @vehicle_detail = VehicleDetail.new
  end

  def create
    @vehicle_detail = VehicleDetail.new(vehicle_detail_params)
    if @vehicle_detail.save
      flash[:success] = t "controller.vehicle_detail.create.success"
      redirect_to vehicle_details_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @vehicle_detail.update(vehicle_detail_params)
      flash[:success] = t "controller.vehicle_detail.update.success"
      redirect_to vehicle_details_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @vehicle_detail.destroy
      flash[:success] = t "controller.vehicle_detail.destroy.success"
    else
      flash[:error] = t "controller.vehicle_detail.destroy.failure"
    end
    redirect_to vehicle_details_path
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

  def load_vehicle_detail
    @vehicle_detail = VehicleDetail.find_by(id: params[:id])
    return unless @vehicle_detail.nil?

    flash[:error] = t "controller.vehicle_detail.not_found"
    redirect_to vehicle_details_path
  end
end
