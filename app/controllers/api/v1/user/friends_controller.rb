module Api
  module V1
    module User
      class FriendsController < AuthorizedController
        def index
          friends = current_user.friends
          render json: User::InfoSerializer.new(paginate(friends, per_page: ::User::FRIENDS_PER_PAGE))
        end
      end
    end
  end
end
