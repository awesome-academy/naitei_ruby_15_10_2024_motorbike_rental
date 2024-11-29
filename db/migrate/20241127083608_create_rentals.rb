class CreateRentals < ActiveRecord::Migration[7.0]
  def change
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
