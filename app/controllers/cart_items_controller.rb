class CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[destroy]
  before_action :load_time, only: %i[index create]
  before_action :validate_time_params, only: %i[index create]
  def index
    @cart_items = current_user.cart_items.includes(:model)
    @total_price = @cart_items.sum(&:total_price)
    @rental_durations = calculate_rental_duration(@start_datetime, @end_datetime)
  end

  def create
    @model = Model.find(params[:model_id])

    vehicle_count = @model.vehicle_free_count(@start_datetime, @end_datetime)
    @rental_durations = calculate_rental_duration(@start_datetime, @end_datetime)

    existing_cart_item = current_user.cart_items.find_by(model_id: params[:model_id])

    if existing_cart_item
      new_quantity = existing_cart_item.quantity + cart_item_params[:quantity].to_i
      if new_quantity > vehicle_count
        redirect_back fallback_location: model_path(@model),
                      alert: t("errors.exceeds_available_quantity", available: vehicle_count)
      else
        existing_cart_item.quantity = new_quantity
        if existing_cart_item.save
          redirect_back fallback_location: model_path(@model), notice: t("controller.cart_items.create.created_success")
        else
          redirect_back fallback_location: model_path(@model),
                        alert: existing_cart_item.errors.full_messages.join(", ")
        end
      end
    elsif cart_item_params[:quantity].to_i > vehicle_count
      redirect_back fallback_location: model_path(@model),
                    alert: t("errors.exceeds_available_quantity", available: vehicle_count)
    else
      @cart_item = current_user.cart_items.build(cart_item_params)
      @cart_item.model_id = params[:model_id]
      @cart_item.rental_durations = @rental_durations
      if @cart_item.save
        redirect_back fallback_location: model_path(@model), notice: t("controller.cart_items.create.created_success")
      else
        redirect_back fallback_location: model_path(@model), alert: @cart_item.errors.full_messages.join(", ")
      end
    end
  end

  def destroy
    @cart_item.destroy
    redirect_back fallback_location: root_path
  end

  private

  def set_cart_item
    @cart_item = current_user.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:start_datetime, :end_datetime, :quantity, :model_id)
  end
end
