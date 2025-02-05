class UsersController < ApplicationController
  load_and_authorize_resource only: :index

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
