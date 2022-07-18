class AddBodyColumnToAbouts < ActiveRecord::Migration[7.0]
  def change
    add_column :abouts, :body, :text
  end
end
