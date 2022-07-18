module Api
  module V1
    class ReactionsController < AuthorizedController
      def create
        result = ::Api::V1::Reactions::CreateService.call(current_user, reaction_param)
        response = if result[:status] == :success
                     { json: Api::V1::Reaction::InfoSerializer.new(result[:model]) }
                   else
                     { json: { errors: result[:errors] }, status: :bad_request }
                   end
        render response
      end

      private

      def reaction_param
        params.permit(:playlist_id, :reaction_type)
      end
    end
  end
end
