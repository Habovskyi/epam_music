class AddTsvectorColumnToSongs < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :songs, :ts_search_vector, :tsvector
    add_index :songs, :ts_search_vector, using: :gin, algorithm: :concurrently
  end
end
