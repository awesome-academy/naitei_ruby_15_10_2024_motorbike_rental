class Api::V1::BaseController < ApplicationController
  before_action :authenticate_request
  attr_reader :current_user

  private

  def authenticate_request
    header = request.headers["Authorization"]

    header = header.split(" ").last if header
    decoded = JsonWebToken.decode(header)

    @current_user = User.find_by(id: decoded[:user_id]) if decoded

    render json: { error: t("controller.rentals.unauthorized") }, status: :unauthorized unless @current_user
  end
end
