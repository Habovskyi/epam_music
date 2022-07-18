module Api
  module V1
    module Comments
      class Create < ApplicationAction
        logic do
          doby Api::V1::Common::Model, parent: ::Playlist, methods: %i[active find], options: %i[params playlist_id]
          doby Api::V1::Common::Authorize, action: :show?
          doby Api::V1::Common::Model, parent: :model, methods: %i[comments new],
                                       options: { user: :current_user }
          doby Api::V1::Forms::Initialize, constant: Comments::CreateForm
          step :create_params
          doby Api::V1::Forms::Validate, params: :create_params
          doby Api::V1::Forms::Save
        end

        private

        def create_params(params:, **)
          params.permit(:text)
        end
      end
    end
  end
end
