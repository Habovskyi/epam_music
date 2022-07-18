module Api
  module V1
    module Users
      class Update < ApplicationAction
        logic do
          doby Api::V1::Forms::Initialize, constant: Api::V1::Users::UpdateForm
          doby Api::V1::Forms::Validate
          doby Api::V1::Forms::Save
          aide Api::V1::Responses::Status, value: :bad_request
        end
      end
    end
  end
end
