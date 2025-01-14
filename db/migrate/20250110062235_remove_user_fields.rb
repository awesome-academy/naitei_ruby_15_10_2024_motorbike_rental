class RemoveUserFields < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :email, :string
    remove_column :users, :password_digest, :string
    remove_column :users, :status, :integer
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
    remove_column :users, :remember_token, :string
  end
end
