module Api
  module V1
    module Comments
      class Index < ApplicationAction
        logic do
          doby Api::V1::Common::Model, parent: ::Playlist, methods: %i[active find],
                                       options: %i[params playlist_id]
          doby Api::V1::Common::Authorize, action: :show?
          doby Api::V1::Common::Model, parent: :model, methods: %i[comments]
          doby Api::V1::Common::Paginate, options: %i[params page], per_page: ::Comment::PER_PLAYLIST_PAGE
        end
      end
    end
  end
end
