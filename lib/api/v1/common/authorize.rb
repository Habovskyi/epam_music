module Api
  module V1
    module Common
      class Authorize
        include ActionPolicy::Behaviour
        include Servicable

        authorize :user
        attr_reader :user

        POLICIES_NAMESPACE = Api::V1

        # rubocop:disable  Metrics/ParameterLists
        def initialize(ctx:, action:, user: :current_user, model: :model, **)
          @ctx = ctx
          @action = action
          @model = ctx[model]
          @user = ctx[user]
        end
        # rubocop:enable  Metrics/ParameterLists

        def call
          authorize! @model, to: @action, namespace: POLICIES_NAMESPACE
        end
      end
    end
  end
end
