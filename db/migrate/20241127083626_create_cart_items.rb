class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :model, null: false, foreign_key: true
      t.decimal :quantity
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.decimal :total_price
      t.timestamps
    end
  end
end
