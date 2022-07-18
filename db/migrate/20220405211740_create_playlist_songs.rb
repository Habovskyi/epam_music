class CreatePlaylistSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :playlist_songs, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :playlist, null: false, foreign_key: true, type: :uuid
      t.references :song, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :playlist_songs, %i[playlist_id song_id], unique: true
  end
end
