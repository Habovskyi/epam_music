module Api
  module V1
    class SongsController < ApiController
      def index
        @songs = paginate(
          filter_options[:search_word] ? ::Song.search(filter_options[:search_word]) : ::Song,
          per_page: ::Song::SEARCH_LIMIT
        )
        options = { include: filter_options[:includes]&.map(&:to_sym) & Song::FullSerializer.includes }
        render json: Song::FullSerializer.new(@songs, options)
      end

      private

      def filter_options
        params.permit(:page, :search_word, includes: [])
      end
    end
  end
end
