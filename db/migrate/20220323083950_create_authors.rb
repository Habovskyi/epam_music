# Initial migration for Authors table
class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors, id: :uuid do |t|
      t.string :nickname, index: { unique: true }

      t.timestamps
    end
  end
end
