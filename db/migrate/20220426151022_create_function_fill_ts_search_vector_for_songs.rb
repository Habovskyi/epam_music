class CreateFunctionFillTsSearchVectorForSongs < ActiveRecord::Migration[7.0]
  def change
    create_function :fill_ts_search_vector_for_songs
  end
end
