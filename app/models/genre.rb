# Genre model
class Genre < ApplicationRecord
  has_many :songs, dependent: :destroy
end
