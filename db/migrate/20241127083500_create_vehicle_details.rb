class CreateVehicleDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicle_details do |t|
      t.references :model, null: false, foreign_key: true
      t.string :number
      t.integer :vehicle_type
      t.integer :engine_capacity
      t.string :image_url
      t.decimal :price_per_day
      t.boolean :available

      t.timestamps
    end
  end
end
