class Admin::ProofsController < ApplicationController
  before_action :set_rental

  def create
    @proof = @rental.proofs.build(proof_params)
    @proof.user = current_user

    if @proof.save
      redirect_to admin_rental_path(@rental), notice: t(".success")
    else
      redirect_to admin_rental_path(@rental), alert: @proof.errors.full_messages.join(", ")
    end
  end

  def destroy
    @proof = @rental.proofs.find(params[:id])
    @proof.image.purge if @proof.image.attached?
    @proof.destroy

    redirect_to admin_rental_path(@rental), notice: t(".success")
  end

  private

  def set_rental
    @rental = Rental.find(params[:rental_id])
  end

  def proof_params
    params.require(:proof).permit(:name, :image, :storage_type)
  end
end
