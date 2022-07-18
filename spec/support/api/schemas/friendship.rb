module Api
  module Schemas
    class Friendship < ApplicationSchema
      USER_RELATION_SCHEMA = Dry::Schema.Params do
        required(:id).filled(:string)
        required(:type).filled(:string)
      end

      FRIENDSHIP = Dry::Schema.Params do
        required(:id).filled(:string)
        required(:type).filled(:string)
        required(:attributes).hash do
          required(:status).filled(:string)
        end
        required(:relationships).hash do
          required(:user_from).hash do
            required(:data).hash(USER_RELATION_SCHEMA)
          end
          required(:user_to).hash do
            required(:data).hash(USER_RELATION_SCHEMA)
          end
        end
      end

      INVITATIONS = Dry::Schema.Params do
        required(:id).filled(:string)
        required(:type).filled(:string)
        required(:attributes).hash do
          required(:status).filled(:string)
          required(:incoming).filled(:bool)
        end
        required(:relationships).hash do
          required(:user_from).hash do
            required(:data).hash(USER_RELATION_SCHEMA)
          end
          required(:user_to).hash do
            required(:data).hash(USER_RELATION_SCHEMA)
          end
        end
      end

      SINGLE_SCHEMA = Dry::Schema.JSON do
        required(:data).hash(FRIENDSHIP)
      end

      MANY_SCHEMA = Dry::Schema.JSON do
        required(:data).array(INVITATIONS)
      end
    end
  end
end
