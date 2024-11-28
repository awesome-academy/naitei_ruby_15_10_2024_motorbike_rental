# frozen_string_literal: true

# This migration creates the 'users' table in the database to store user-related
# information such as name, email, phone number, role, status, and authentication
# details (provider and uid). It also includes a password_digest column to securely
# store user passwords. The email column is indexed to ensure uniqueness.
#
# The 'role' and 'status' columns are stored as integers, where each value corresponds
# to a specific role (e.g., user, admin) and user status (e.g., active, banned).
#
# The migration also automatically adds timestamps to track when each user record
# is created or updated.
class CreateUsers < ActiveRecord::Migration[7.0]
  def change # rubocop:disable Metrics/MethodLength
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :phone_number
      t.integer :role
      t.integer :status
      t.string :provider
      t.string :uid

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
