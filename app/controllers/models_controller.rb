class ModelsController < ApplicationController
  include Pagy::Backend
  before_action :load_model, only: %i[update edit show]
  def index
    @pagy, @models = pagy(Model.ordered_by_vehicle_count)
  end

  def show
    @vehicle_details = @model.vehicle_details.includes(:image_attachment)
    @related_models = Model.related_to(@model.id, @model.brand_id, @model.vehicle_type)
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
