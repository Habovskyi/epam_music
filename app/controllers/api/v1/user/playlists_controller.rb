module Api
  module V1
    module User
      class PlaylistsController < AuthorizedController
        def index
          playlists = Api::V1::Users::Playlists::Index.call(current_user:, params:)[:model]
          render json: serialize(Playlist::InfoSerializer, playlists)
        end
      end
    end
  end
end
