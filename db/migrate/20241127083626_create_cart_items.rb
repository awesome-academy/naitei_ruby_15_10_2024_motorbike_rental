# frozen_string_literal: true

# This migration creates the 'cart_items' table in the database, which is used to store
# items that users have added to their shopping carts. The table links users with the
# specific vehicles they have selected for rental. It establishes many-to-many relationships
# between users and vehicle details, allowing users to store and manage selected vehicles
# before proceeding with a rental.
#
# - `user_id`: a foreign key reference to the 'users' table, linking each cart item to
#   a specific user who added the vehicle to their cart.
# - `vehicle_detail_id`: a foreign key reference to the 'vehicle_details' table, linking
#   each cart item to a specific vehicle detail (e.g., vehicle model, type, etc.).
#
# The migration also includes automatic timestamping to track when each cart item record
# is created or updated.
class CreateCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :vehicle_detail, null: false, foreign_key: true

      t.timestamps
    end
  end
end
