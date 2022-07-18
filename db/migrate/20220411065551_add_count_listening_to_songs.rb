class AddCountListeningToSongs < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :count_listening, :integer, default: 0
  end
end
