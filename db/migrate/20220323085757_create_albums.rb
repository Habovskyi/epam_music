# Initial migration for Albums table
class CreateAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :albums, id: :uuid do |t|
      t.string :title

      t.timestamps
    end
  end
end
