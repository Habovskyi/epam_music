module Api
  module V1
    module User
      class FriendshipsController < AuthorizedController
        def index
          friendships = paginate(current_user.friendships.pending, per_page: ::Friendship::INDEX_LIMIT)
          options = { params: { current_user: } }
          render json: Api::V1::Friendship::DetailsSerializer.new(friendships, options)
        end

        def destroy
          friendship = current_user.friendships.find(params[:id])
          FriendshipMailer.with(user_to: friendship.user_to, user_from: friendship.user_from)
                          .declined_mail.deliver_later

          friendship.destroy
        end

        def create
          result = Api::V1::Friendships::Create.call(current_user:, params: create_params)
          response = if result.success?
                       send_invintation_mail(result[:model])
                       { json: Api::V1::Friendship::InfoSerializer.new(result[:model]) }
                     else
                       { json: { errors: result.errors }, status: :bad_request }
                     end
          render response
        end

        def update
          friendship = current_user.friendship_to.pending.find(params[:id])
          friendship.update(status: :accepted)
          FriendshipMailer.with(friendship:)
                          .accepted_mail.deliver_later
        end

        private

        def send_invintation_mail(friendship)
          FriendshipMailer.with(friendship:).invintation_mail.deliver_later
        end

        def create_params
          params.permit(:user_to_id)
        end
      end
    end
  end
end
