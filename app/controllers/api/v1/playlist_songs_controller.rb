module Api
  module V1
    class PlaylistSongsController < AuthorizedController
      skip_before_action :unauthorized_request, only: [:index]

      def index
        @playlist = ::Playlist.find(params[:playlist_id])
        authorize! @playlist, to: :show?
        render json: serialize(PlaylistSong::InfoSerializer,
                               paginate(@playlist.playlist_songs,
                                        per_page: ::Playlist::SONGS_PER_PAGE),
                               params: { shared: @playlist.shared? })
      end

      def create
        playlist_song_form = Api::V1::Users::PlaylistSongs::CreateForm.new(find_playlist.playlist_songs
                                                                                        .new(user: current_user))
        response = if playlist_song_form.validate(**playlist_song_params)
                     playlist_song_form.save
                     { json: serialize(PlaylistSong::InfoSerializer, playlist_song_form.model,
                                       params: { shared: playlist_song_form.model.playlist.shared? }) }
                   else
                     { json: { errors: playlist_song_form.errors }, status: :bad_request }
                   end

        render response
      end

      def destroy
        playlist_song = ::PlaylistSong.joins(playlist: :user)
                                      .where(user: { id: current_user.id })
                                      .find_by!(song_id: params[:id], playlist_id: params[:playlist_id])

        playlist_song.destroy
      end

      private

      def find_playlist
        current_user.user_and_shared_playlists.find(params[:playlist_id])
      end

      def playlist_song_params
        params.permit(:song_id, :playlist_id)
      end
    end
  end
end
