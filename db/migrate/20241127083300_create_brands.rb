# frozen_string_literal: true

# This migration creates the 'brands' table in the database with the necessary
# columns: name (string) and logo (string). It also adds timestamps to record
# the creation and update times of each brand entry.
#
# The 'brands' table will store information about various brands, including
# their names and logos. The timestamps will automatically manage the
# created_at and updated_at columns.
class CreateBrands < ActiveRecord::Migration[7.0]
  def change
    create_table :brands do |t|
      t.string :name
      t.string :logo

      t.timestamps
    end
  end
end
