module Api
  module V1
    module Friendships
      class Create < ApplicationAction
        logic do
          doby Api::V1::Common::Model, parent: :current_user, methods: %i[friendship_from build]
          doby Api::V1::Forms::Initialize, constant: Friendships::CreateForm
          doby Api::V1::Forms::Validate
          doby Api::V1::Forms::Save
        end
      end
    end
  end
end
