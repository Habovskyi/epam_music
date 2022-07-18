module Api
  module V1
    class CurrentUsersController < AuthorizedController
      def show
        render json: User::InfoSerializer.new(current_user)
      end

      def update
        result = Api::V1::Users::Update.call(model: current_user, params: user_params)
        response = if result.success?
                     { json: User::InfoSerializer.new(result[:model]) }
                   else
                     { json: result.errors, status: result[:status] }
                   end
        render response
      end

      def destroy
        Api::V1::Users::Destroy.call(model: current_user)
      end

      private

      def user_params
        params.permit(:username, :first_name, :last_name, :avatar)
      end
    end
  end
end
