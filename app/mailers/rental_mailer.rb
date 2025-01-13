class RentalMailer < ApplicationMailer
  default from: "no-reply@example.com"

  def approval_email(rental)
    @rental = rental
    @user = rental.user
    @rental_vehicles = @rental.rental_vehicles.includes(:vehicle_detail)
    @vehicle_details = @rental_vehicles.map(&:vehicle_detail)
    mail(to: @user.email, subject: t("views.rentals.email.approval_message"))
  end

  def rejection_email(rental)
    @rental = rental
    @user = rental.user
    @rental_vehicles = @rental.rental_vehicles.includes(:vehicle_detail)
    @vehicle_details = @rental_vehicles.map(&:vehicle_detail)
    @decline_reason = rental.decline_reason
    mail(to: @user.email, subject: t("views.rentals.email.rejection_message"))
  end
end
