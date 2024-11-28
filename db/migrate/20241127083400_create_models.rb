# frozen_string_literal: true

# This migration creates the 'models' table in the database with the necessary
# columns: name (string), logo (string), and a foreign key reference to the
# 'brands' table to establish the relationship between models and brands.
#
# The 'models' table will store information about various models associated
# with brands, including their names and logos. The foreign key reference
# ensures that each model is associated with an existing brand. Timestamps
# will also be added automatically to record the creation and update times
# of each model entry.
class CreateModels < ActiveRecord::Migration[7.0]
  def change
    create_table :models do |t|
      t.string :name
      t.string :logo
      t.references :brand, null: false, foreign_key: true

      t.timestamps
    end
  end
end
