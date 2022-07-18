module Api
  module V1
    module Home
      class Songs < ApplicationAction
        TYPES = {
          'latest' => :latest,
          'popular' => :popular,
          'popular_by_genres' => :by_genres
        }.freeze

        logic do
          doby Api::V1::Common::FeatureToggle, feature_name: :songs_endpoint
          doby Api::V1::Common::ValidateHashKey, hash: TYPES, key: :type
          aide Api::V1::Responses::Status, value: :bad_request
          step :model
        end

        private

        def model(type:, **)
          ctx[:model] = ::Song.public_send(TYPES[type])
        end
      end
    end
  end
end
