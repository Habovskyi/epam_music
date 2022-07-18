module Api
  module V1
    module Users
      module Playlists
        class Index < ApplicationAction
          SHARED_TYPE = 'shared'.freeze

          logic do
            step :model
            doby Api::V1::Common::Paginate, per_page: ::User::PLAYLISTS_PER_PAGE, options: %i[params page]
          end

          private

          def model(params:, current_user:, **)
            ctx[:model] =
              params[:type] == SHARED_TYPE ? current_user.shared_playlists.active : current_user.playlists.active
          end
        end
      end
    end
  end
end
