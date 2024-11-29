class CreateModels < ActiveRecord::Migration[7.0]
  def change
    create_table :models do |t|
      t.string :name
      t.references :brand, null: false, foreign_key: true
      t.integer :vehicle_type
      t.integer :engine_capacity
      t.decimal :price_per_day
      t.timestamps
    end
  end
end
