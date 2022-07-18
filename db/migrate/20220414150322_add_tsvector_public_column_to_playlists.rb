class AddTsvectorPublicColumnToPlaylists < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :playlists, :ts_vector_public, :tsvector
    add_index :playlists, :ts_vector_public, using: :gin, algorithm: :concurrently
  end
end
