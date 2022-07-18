class CreateTriggerPlaylistsTsVectorPublicContentTrigger < ActiveRecord::Migration[7.0]
  def change
    create_trigger :playlists_ts_vector_public_content_trigger, on: :playlists
    Playlist.find_each(&:touch)
  end
end
