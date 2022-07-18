# Initial migration for Users table
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username, index: { unique: true, name: 'unique_usernames' }
      t.string :email, index: { unique: true, name: 'unique_emails' }
      t.string :first_name
      t.string :last_name
      t.integer :playlists_created, default: 0
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
