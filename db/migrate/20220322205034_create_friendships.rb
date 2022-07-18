class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships, id: :uuid do |t|
      t.references :user_from, index: true, foreign_key: { to_table: :users }, type: :uuid
      t.references :user_to, index: true, foreign_key: { to_table: :users }, type: :uuid
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
