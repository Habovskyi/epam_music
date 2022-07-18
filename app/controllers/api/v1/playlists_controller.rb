module Api
  module V1
    class PlaylistsController < AuthorizedController
      skip_before_action :unauthorized_request, only: %i[index show]

      def show
        playlist = ::Playlist.find(params[:id])
        authorize! playlist, to: :show?
        render json: serialize(Playlist::InfoSerializer, playlist)
      end

      def index
        playlists = paginate(::Playlist.general_home(filter_options), per_page: ::Playlist::SEARCH_LIMIT)
        render json: serialize(Playlist::HomeSerializer, playlists)
      end

      def destroy
        playlist = ::Playlist.find(params[:id])
        authorize! playlist, to: :destroy?

        playlist.update(deleted_at: Time.zone.now)
      end

      def create
        playlist_form = Playlists::BaseForm.new(::Playlist.new)
        response = if playlist_form.validate(create_options)
                     playlist_form.save
                     handle_playlist_creation(current_user)
                     { json: serialize(Playlist::InfoSerializer, playlist_form.model), status: :created }
                   else
                     { json: { errors: playlist_form.errors }, status: :bad_request }
                   end
        render response
      end

      def update
        playlist_form = Playlists::BaseForm.new(::Playlist.find(params[:id]))
        authorize! playlist_form.model, to: :update?
        response = if playlist_form.validate(playlist_options)
                     playlist_form.save
                     { json: serialize(Playlist::InfoSerializer, playlist_form.model) }
                   else
                     { json: { errors: playlist_form.errors }, status: :bad_request }
                   end

        render response
      end

      private

      def create_options
        { user: current_user }.merge(playlist_options)
      end

      def filter_options
        params.permit(:sort_by, :sort_order, :page, :s)
      end

      def playlist_options
        params.permit(:title, :logo, :description, :visibility)
      end

      def handle_playlist_creation(playlist_user)
        playlist_user.update(playlists_created: playlist_user.playlists_created + 1)
        ::Api::V1::Statistics::AchievementService.new(playlist_user).call
      end
    end
  end
end
