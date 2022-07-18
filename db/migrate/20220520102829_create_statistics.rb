class CreateStatistics < ActiveRecord::Migration[7.0]
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def change
    create_table :statistics, id: :uuid do |t|
      t.integer :new_users, default: 0, null: false
      t.integer :new_deleted_users, default: 0, null: false
      t.integer :new_playlists, default: 0, null: false
      t.integer :new_deleted_playlists, default: 0, null: false
      t.integer :new_playlist_songs, default: 0, null: false
      t.integer :new_friendships, default: 0, null: false
      t.integer :new_accepted_friendships, default: 0, null: false
      t.integer :new_songs, default: 0, null: false
      t.integer :new_genres, default: 0, null: false
      t.integer :new_authors, default: 0, null: false
      t.integer :total_users, default: 0, null: false
      t.integer :total_deleted_users, default: 0, null: false
      t.integer :total_playlists, default: 0, null: false
      t.integer :total_songs, default: 0, null: false
      t.integer :total_genres, default: 0, null: false
      t.integer :total_authors, default: 0, null: false

      t.timestamps
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
