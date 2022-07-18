module Api
  module V1
    module Home
      class PlaylistsInfo < ApplicationAction
        TYPES = {
          'latest' => :latest_added,
          'popular' => :popular,
          'featured' => :featured
        }.freeze

        logic do
          doby Api::V1::Common::FeatureToggle, feature_name: :playlists_info_endpoint
          doby Api::V1::Common::ValidateHashKey, hash: TYPES, key: :type
          aide Api::V1::Responses::Status, value: :bad_request
          step :model
        end

        private

        def model(type:, **)
          ctx[:model] = ::Playlist.active.public_send(TYPES[type])
        end
      end
    end
  end
end
