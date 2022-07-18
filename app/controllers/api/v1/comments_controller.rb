module Api
  module V1
    class CommentsController < AuthorizedController
      skip_before_action :unauthorized_request, only: :index

      def index
        result = Api::V1::Comments::Index.call(params:, current_user:)
        render responses(result)
      end

      def create
        result = Api::V1::Comments::Create.call(params:, current_user:)
        render responses(result)
      end

      private

      def responses(result)
        if result.success?
          { json: Api::V1::Comment::InfoSerializer.new(result[:model]) }
        elsif result[:model].nil?
          { json: { errors: result.errors }, status: :not_found }
        else
          { json: { errors: result.errors }, status: :unprocessable_entity }
        end
      end
    end
  end
end
