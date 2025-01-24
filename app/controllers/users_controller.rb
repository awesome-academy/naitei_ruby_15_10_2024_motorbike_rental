class UsersController < ApplicationController
  before_action :authorize_admin, only: :index
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    return unless @user != current_user

    flash[:alert] = t "views.user.show.load_false"
    redirect_to root_path
  end
end
