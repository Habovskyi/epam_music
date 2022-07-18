class CreateSongs < ActiveRecord::Migration[7.0]
  def change
    create_table :songs, id: :uuid do |t|
      t.string :title

      t.references :album, null: true, foreign_key: true, type: :uuid
      t.references :genre, null: false, foreign_key: true, type: :uuid
      t.references :author, null: false, foreign_key: true, type: :uuid

      t.boolean :featured, default: false

      t.timestamps
    end
  end
end
