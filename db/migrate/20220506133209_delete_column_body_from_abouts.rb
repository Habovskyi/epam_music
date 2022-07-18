class DeleteColumnBodyFromAbouts < ActiveRecord::Migration[7.0]
  def change
    safety_assured { remove_column :abouts, :body, :text }
  end
end
