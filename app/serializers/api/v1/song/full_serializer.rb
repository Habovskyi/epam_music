module Api
  module V1
    module Song
      class FullSerializer < ApplicationSerializer
        set_type :song

        attributes :title

        belongs_to :album, serializer: Api::V1::Album::InfoSerializer
        belongs_to :author, serializer: Api::V1::Author::InfoSerializer
        belongs_to :genre, serializer: Api::V1::Genre::InfoSerializer

        def self.includes
          %i[author album genre]
        end
      end
    end
  end
end
