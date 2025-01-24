class Users::ConfirmationsController < Devise::ConfirmationsController
  protected

  def after_confirmation_path_for(_resource_name, _resource)
    new_user_session_path(locale: I18n.locale)
  end
end
