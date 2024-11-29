class AddRentalDurationsToCartItems < ActiveRecord::Migration[7.0]
  def change
    add_column :cart_items, :rental_durations, :float
  end
end
