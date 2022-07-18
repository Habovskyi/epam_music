module Api
  module V1
    class UsersController < AuthorizedController
      def show
        render json: User::InfoSerializer.new(::User.find(params[:id])), status: :ok
      end

      def search_new_user
        users = current_user.not_friends.search(params[:email])
        search_response = paginate(users, per_page: ::User::SEARCH_LIMIT)
        render json: User::InfoSerializer.new(search_response)
      end
    end
  end
end
