# Initial migration for Playlists table
class CreatePlaylists < ActiveRecord::Migration[7.0]
  def change
    create_table :playlists, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :title, index: true
      t.text :logo_data
      t.integer :visibility, default: 0
      t.boolean :featured, default: false
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
