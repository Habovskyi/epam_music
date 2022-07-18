module Api
  module V1
    class HomeController < ApiController
      def songs
        result = Api::V1::Home::Songs.call(includes: home_params[:includes], type: home_params[:type])
        response = if result.success?
                     options = params[:includes]&.map(&:to_sym) & Song::SongSerializer.includes
                     { json: Song::SongSerializer.new(result[:model], include: options) }
                   else
                     { status: result[:status] }
                   end
        render response
      end

      def users_info
        result = Api::V1::Home::UsersInfo.call(type: home_params[:type])
        response = if result.success?
                     { json: User::HomeSerializer.new(result[:model]) }
                   else
                     { status: result[:status] }
                   end
        render response
      end

      def playlists_info
        result = Api::V1::Home::PlaylistsInfo.call(type: home_params[:type])
        response = if result.success?
                     { json: Playlist::HomeSerializer.new(result[:model]) }
                   else
                     { status: result[:status] }
                   end
        render response
      end

      private

      def home_params
        params.permit(:type, includes: [])
      end
    end
  end
end
