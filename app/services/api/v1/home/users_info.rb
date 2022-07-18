module Api
  module V1
    module Home
      class UsersInfo < ApplicationAction
        TYPES = {
          'best_contributors' => :best_contributors,
          'most_friendly' => :most_friendly
        }.freeze

        logic do
          doby Api::V1::Common::FeatureToggle, feature_name: :users_info_endpoint
          doby Api::V1::Common::ValidateHashKey, hash: TYPES, key: :type
          aide Api::V1::Responses::Status, value: :bad_request
          step :model
        end

        private

        def model(type:, **)
          ctx[:model] = ::User.active.public_send(TYPES[type])
        end
      end
    end
  end
end
