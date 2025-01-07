class ModelsController < ApplicationController
  include Pagy::Backend
  before_action :load_model, only: %i[update edit show]
  before_action :load_time, only: %i[index show]
  before_action :validate_time_params, only: %i[index show]
  before_action :authorize_admin, only: %i[update edit]

  def index
    session[:start_datetime] = @start_datetime
    session[:end_datetime] = @end_datetime

    @models = Model.filtered(params[:brand_id], params[:min_price], params[:max_price], params[:vehicle_type],
                             params[:engine_capacity])

    @pagy, @models = pagy(@models)

    @brands = Brand.all
    @vehicle_types = Model.vehicle_types.keys
    @engine_capacities = Model.engine_capacities.keys
  end

  def show
    @vehicle_details = @model.vehicle_details.includes(:image_attachment)
    @related_models = Model.related_to(@model.id, @model.brand_id, @model.vehicle_type)
    @rental_duration = calculate_rental_duration(@start_datetime, @end_datetime)
  end

  def edit; end

  def update
    if @model.update(model_params)
      flash[:success] = t("controller.model.update.success")
      redirect_to @model
    else
      flash[:error] = t("controller.model.update.error")
      render :edit
    end
  end

  private

  def load_model
    @model = Model.find_by(id: params[:id])
    return unless @model.nil?

    flash[:error] = t "controller.model.not_found"
    redirect_to models_path
  end

  def model_params
    params.require(:model).permit(:price_per_day)
  end
end
