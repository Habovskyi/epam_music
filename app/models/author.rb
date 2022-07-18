# Author model
class Author < ApplicationRecord
  has_many :songs, dependent: :destroy

  def display_name
    nickname
  end
end
