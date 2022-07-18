module Api
  module V1
    module Song
      class SongSerializer
        include FastJsonapi::ObjectSerializer
        attributes :title, :count_listening, :created_at

        belongs_to :genre, key: :genre, serializer: Api::V1::Genre::InfoSerializer

        def self.includes
          %i[genre]
        end
      end
    end
  end
end
