module Api
  module Schemas
    class Comment < ApplicationSchema
      COMMENT = Dry::Schema.Params do
        required(:id).filled(:string)
        required(:type).filled(:string)
        required(:attributes).hash do
          required(:text).filled(:string)
        end
        required(:relationships).hash do
          required(:playlist).hash do
            required(:data).value(:hash)
          end
          required(:user).hash do
            required(:data).value(:hash)
          end
        end
      end

      SINGLE_SCHEMA = Dry::Schema.JSON do
        required(:data).hash(COMMENT)
        optional(:included).array(:hash)
      end

      MANY_SCHEMA = Dry::Schema.JSON do
        required(:data).array(COMMENT)
        optional(:included).array(:hash)
      end
    end
  end
end
