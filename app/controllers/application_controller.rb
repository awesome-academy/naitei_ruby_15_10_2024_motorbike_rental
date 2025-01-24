class ApplicationController < ActionController::Base # rubocop:disable Metrics/ClassLength
  include Pagy::Backend

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :load_time, :validate_time_params, :calculate_rental_duration, :clear_cart
  helper_method :user_signed_in?, :current_user, :authenticate_user!

  def load_time
    if params[:start_datetime].present? && params[:end_datetime].present?
      load_time_from_params
    elsif session[:start_datetime].present? && session[:end_datetime].present?
      load_time_from_session
    else
      set_default_times
    end
  end

  def validate_time_params
    return set_default_times if @start_datetime.blank? || @end_datetime.blank?

    begin
      start_datetime = @start_datetime
      end_datetime = @end_datetime

      if start_datetime < Time.current
        flash.now[:error] = t("errors.invalid_datetime")
        set_default_times
        return
      end

      if end_datetime <= start_datetime
        flash.now[:error] = t("errors.invalid_datetime")
        set_default_times
        return
      end

      min_duration = 4.hours
      if (end_datetime - start_datetime) < min_duration
        flash.now[:error] =
          t("errors.minimum_duration", hours: Rails.application.config_for(:settings).dig(:rental, :minimum_duration))
        set_default_times
        nil
      end
    rescue ArgumentError
      flash.now[:error] = t("errors.invalid_datetime")
      set_default_times
    end
  end

  def calculate_rental_duration(start_time, end_time)
    duration = (end_time - start_time) / 1.day
    hours_remainder = (duration % 1) * 24

    base_days = duration.floor
    if hours_remainder.positive?
      base_days += hours_remainder > 12 ? 1 : 0.5
    end

    base_days
  end

  def clear_cart
    current_user.cart_items.destroy_all
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name phone_number])
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:email, :password, :remember_me)
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_default_times
    current_time = Time.current
    @start_datetime = if current_time.min < 30
                        current_time.change(min: 30, sec: 0)
                      else
                        current_time.change(min: 0, sec: 0).advance(hours: 1)
                      end
    @end_datetime = if 1.day.from_now.min < 30
                      1.day.from_now.change(min: 30, sec: 0)
                    else
                      1.day.from_now.change(min: 0, sec: 0).advance(hours: 1)
                    end
  end

  def load_time_from_params
    @start_datetime = parse_time(params[:start_datetime])
    @end_datetime = parse_time(params[:end_datetime])
    return unless authenticate_user!

    clear_cart
  end

  def load_time_from_session
    @start_datetime = parse_time(session[:start_datetime])
    @end_datetime = parse_time(session[:end_datetime])
  end

  def parse_time(time_value)
    time_value.is_a?(String) ? Time.zone.parse(time_value) : time_value
  end

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = t "controller.rentals.unauthorized"
    if user_signed_in?
      redirect_to root_path
    else
      redirect_to new_user_session_path
    end
  end
end
