class CreateTriggerSongsTsSearchVectorContentTrigger < ActiveRecord::Migration[7.0]
  def change
    create_trigger :songs_ts_search_vector_content_trigger, on: :songs
    Song.find_each(&:touch)
  end
end
