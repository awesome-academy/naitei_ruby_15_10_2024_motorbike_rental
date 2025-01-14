class CartItemsController < ApplicationController # rubocop:disable Metrics/ClassLength
  before_action :set_cart_item, only: %i[destroy update_quantity]
  before_action :load_time, only: %i[index create]
  before_action :validate_time_params, only: %i[index create]
  before_action :logged_in_user
  before_action :check_cart_item_quantity, only: %i[index]
  def index
    @cart_items = current_user.cart_items.includes(:model)
    @total_price = @cart_items.sum(&:total_price)
    @rental_durations = calculate_rental_duration(@start_datetime, @end_datetime)
  end

  def create
    @model = Model.find(params[:model_id])
    vehicle_count = @model.vehicle_free_count(@start_datetime, @end_datetime)
    @rental_durations = calculate_rental_duration(@start_datetime, @end_datetime)

    if rent_now?
      handle_rent_now(vehicle_count)
    else
      handle_add_to_cart(vehicle_count)
    end
  end

  def destroy
    @cart_item.destroy
    redirect_back fallback_location: root_path
  end

  def update_quantity
    new_quantity = params[:quantity].to_i
    available_quantity = @cart_item.model.vehicle_free_count(@cart_item.start_datetime, @cart_item.end_datetime)

    @cart_item.update(quantity: new_quantity) if new_quantity <= available_quantity
    redirect_back fallback_location: cart_items_path
  end

  private

  def rent_now?
    params[:cart_item][:rent_now] == true
  end

  def handle_rent_now(vehicle_count)
    existing_cart_item = current_user.cart_items.find_by(model_id: params[:model_id])

    if existing_cart_item
      if existing_cart_item.quantity >= vehicle_count
        redirect_back fallback_location: model_path(@model),
                      alert: t("errors.exceeds_available_quantity", available: vehicle_count)
        return
      end
      existing_cart_item.quantity += 1
      if existing_cart_item.save
        redirect_to cart_items_path
      else
        redirect_back fallback_location: model_path(@model),
                      alert: existing_cart_item.errors.full_messages.join(", ")
      end
    else
      @cart_item = build_new_cart_item(1)
      if @cart_item.save
        redirect_to cart_items_path
      else
        redirect_back fallback_location: model_path(@model),
                      alert: @cart_item.errors.full_messages.join(", ")
      end
    end
  end

  def handle_add_to_cart(vehicle_count)
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
      @cart_item = build_new_cart_item(cart_item_params[:quantity].to_i)
      if @cart_item.save
        redirect_back fallback_location: model_path(@model), notice: t("controller.cart_items.create.created_success")
      else
        redirect_back fallback_location: model_path(@model), alert: @cart_item.errors.full_messages.join(", ")
      end
    end
  end

  def build_new_cart_item(quantity)
    current_user.cart_items.build(
      cart_item_params.merge(
        model_id: params[:model_id],
        rental_durations: @rental_durations,
        quantity: quantity
      )
    )
  end

  def set_cart_item
    @cart_item = current_user.cart_items.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:start_datetime, :end_datetime, :quantity, :model_id)
  end

  def check_cart_item_quantity
    current_user.cart_items.each do |cart_item|
      available_quantity = cart_item.model.vehicle_free_count(cart_item.start_datetime, cart_item.end_datetime)
      next unless cart_item.quantity > available_quantity

      cart_item.update(quantity: available_quantity)
      cart_item.save
    end
  end
end
