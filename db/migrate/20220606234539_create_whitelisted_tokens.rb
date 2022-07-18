class CreateWhitelistedTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :whitelisted_tokens, id: :uuid do |t|
      t.string :crypted_token
      t.timestamptz :expiration
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    add_index(:whitelisted_tokens, :crypted_token, using: 'hash')
  end
end
