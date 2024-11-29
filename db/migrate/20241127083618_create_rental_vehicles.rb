# frozen_string_literal: true

class CreateRentalVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :rental_vehicles do |t|
      t.references :rental, null: false, foreign_key: true
      t.references :vehicle_detail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
