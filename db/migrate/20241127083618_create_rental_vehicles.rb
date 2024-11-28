# frozen_string_literal: true

# This migration creates the 'rental_vehicles' table in the database, which is
# used to associate specific vehicles with rental transactions. The table establishes
# relationships between the 'rentals' table and the 'vehicle_details' table, creating
# many-to-many associations between rental records and vehicle details.
#
# - `rental_id`: a foreign key reference to the 'rentals' table, linking each record
#   to a specific rental transaction.
# - `vehicle_detail_id`: a foreign key reference to the 'vehicle_details' table,
#   linking each record to a specific vehicle detail (e.g., vehicle model, type, etc.).
#
# The migration also includes automatic timestamping to track when each rental vehicle
# record is created or updated.
class CreateRentalVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :rental_vehicles do |t|
      t.references :rental, null: false, foreign_key: true
      t.references :vehicle_detail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
