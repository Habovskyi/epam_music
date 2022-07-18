class AddTsvectorColumnToUsers < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :users, :ts_search_vector, :tsvector
    add_index :users, :ts_search_vector, using: :gin, algorithm: :concurrently
    create_function :fill_ts_search_vector_for_users
    create_trigger :users_ts_search_vector_content_trigger, on: :users
    User.find_each(&:touch)
  end
end
