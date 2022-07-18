# Initial migration for Genres table
class CreateGenres < ActiveRecord::Migration[7.0]
  def change
    create_table :genres, id: :uuid do |t|
      t.string :name, index: { unique: true }

      t.timestamps
    end
  end
end
