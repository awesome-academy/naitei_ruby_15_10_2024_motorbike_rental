class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :vehicle_detail, null: false, foreign_key: true
      t.decimal :quantity

      t.timestamps
    end
  end
end
