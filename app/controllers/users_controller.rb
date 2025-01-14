class UsersController < ApplicationController
  before_action :authorize_admin, only: :index
  before_action :set_user, only: %i[show ban]
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    return unless @user != current_user

    flash[:alert] = t "views.user.show.load_false"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_session_path, notice: t("notices.user_registered")
    else
      flash.now[:alert] = t("notices.user_registration_failed")
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(User::USER_PARAMS)
  end

  def set_user
    @user = User.find_by(id: params[:id])
    return unless @user.nil?

    flash[:error] = t("controller.users.not_found")
    redirect_to root_path
  end
end
