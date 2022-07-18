class CreateFunctionFillTsVectorPublicForPlaylists < ActiveRecord::Migration[7.0]
  def change
    create_function :fill_ts_vector_public_for_playlists
  end
end
