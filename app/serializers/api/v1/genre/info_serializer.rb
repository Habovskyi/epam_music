module Api
  module V1
    module Genre
      class InfoSerializer < ApplicationSerializer
        set_type :genre
        attributes :name
      end
    end
  end
end
