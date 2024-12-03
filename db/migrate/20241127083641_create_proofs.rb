# frozen_string_literal: true

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
