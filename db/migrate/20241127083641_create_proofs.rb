# frozen_string_literal: true

# This migration creates the 'proofs' table in the database, which is used to store
# proof documents related to a rental transaction. This table is designed to store
# evidence or documents (e.g., images or receipts) that users may upload to support
# their rental activities. It links each proof to a specific user and rental.
#
# - `name`: the name of the proof file or document.
# - `image_url`: a URL or path where the proof image is stored.
# - `storage_type`: an integer that indicates the type of storage used (e.g., local or cloud storage).
# - `user_id`: a foreign key reference to the 'users' table, linking each proof to the user who uploaded it.
# - `rental_id`: a foreign key reference to the 'rentals' table, linking each proof to the specific rental it relates to
#
# The migration also includes automatic timestamping to track when each proof record
# is created or updated.
class CreateProofs < ActiveRecord::Migration[7.0]
  def change
    create_table :proofs do |t|
      t.string :name
      t.string :image_url
      t.integer :storage_type
      t.references :user, null: false, foreign_key: true
      t.references :rental, null: false, foreign_key: true

      t.timestamps
    end
  end
end
