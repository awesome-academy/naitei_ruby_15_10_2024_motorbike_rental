# frozen_string_literal: true

# This migration creates the 'vehicle_details' table in the database with
# the necessary columns: model reference, number (string), vehicle_type
# (integer), engine_capacity (integer), price_per_day (decimal), and available
# (boolean). The model reference establishes a foreign key relationship between
# the vehicle details and the associated model.
#
# The 'vehicle_details' table will store information about different vehicles,
# including their unique identifiers (number), type, engine capacity, price per day,
# and availability status. Timestamps will also be automatically added to record
# the creation and update times of each vehicle detail entry.
class CreateVehicleDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicle_details do |t|
      t.references :model, null: false, foreign_key: true
      t.string :number
      t.integer :vehicle_type
      t.integer :engine_capacity
      t.decimal :price_per_day
      t.boolean :available

      t.timestamps
    end
  end
end
