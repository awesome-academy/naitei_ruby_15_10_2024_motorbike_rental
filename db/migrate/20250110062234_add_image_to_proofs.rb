class AddImageToProofs < ActiveRecord::Migration[7.0]
  def change
    remove_column :proofs, :image_url, :string
    add_reference :proofs, :image, null: true, foreign_key: { to_table: :active_storage_attachments }
  end
end
