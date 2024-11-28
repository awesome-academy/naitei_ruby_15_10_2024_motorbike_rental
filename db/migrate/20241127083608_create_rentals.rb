# frozen_string_literal: true

# This migration creates the 'rentals' table in the database to store rental-related
# information. It includes references to the 'users' table (as a foreign key), along
# with various fields to capture rental details such as:
#
# - `name`: the name of the person renting the vehicle.
# - `phone_number`: the contact number of the renter.
# - `delivery_location`: the location where the vehicle is delivered.
# - `decline_reason`: a text field to store reasons for rental request rejection (if applicable).
# - `start_datetime`: the starting date and time of the rental.
# - `end_datetime`: the expected end date and time of the rental.
# - `return_datetime`: the actual return date and time of the rental.
# - `status`: an integer field to store the current status of the rental (e.g., pending, completed).
# - `total_price`: the total price of the rental.
#
# The migration also includes automatic timestamping for tracking record creation and updates.
class CreateRentals < ActiveRecord::Migration[7.0]
  def change # rubocop:disable Metrics/MethodLength
    create_table :rentals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :phone_number
      t.string :delivery_location
      t.text :decline_reason
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.datetime :return_datetime
      t.integer :status
      t.decimal :total_price

      t.timestamps
    end
  end
end
