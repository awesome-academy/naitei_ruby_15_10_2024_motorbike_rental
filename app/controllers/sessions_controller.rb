class SessionsController < ApplicationController
  def new; end

  def create
    user = User.authenticate(params[:login], params[:password])

    if user
      session[:user_id] = user.id
      remember_user(user) if params[:remember_me] == "1"
      redirect_to root_path, notice: t("sessions.login_success")
    else
      flash.now[:danger] = t "sessions.invalid_credentials"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    forget_user(current_user) if current_user
    session[:user_id] = nil
    redirect_to root_path, notice: t("sessions.logout_success")
  end

  private

  def remember_user(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget_user(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
