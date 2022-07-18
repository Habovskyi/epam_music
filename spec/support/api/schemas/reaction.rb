module Api
  module Schemas
    class Reaction < ApplicationSchema
      USER = Dry::Schema.Params do
        required(:user).hash do
          required(:data).hash do
            required(:id).filled(:string)
            required(:type).filled(:string)
          end
        end
      end

      PLAYLIST = Dry::Schema.Params do
        required(:playlist).hash do
          required(:data).hash do
            required(:id).filled(:string)
            required(:type).filled(:string)
          end
        end
      end

      DEFAULT_SCHEMA = Dry::Schema.Params do
        required(:id).filled(:string)
        required(:type).filled(:string)
        required(:attributes).hash do
          required(:reaction_type).filled(:string)
        end
        required(:relationships).hash(USER & PLAYLIST)
      end

      SINGLE_SCHEMA = Dry::Schema.JSON do
        required(:data).hash(DEFAULT_SCHEMA)
        optional(:included).array(:hash)
      end

      MANY_SCHEMA = Dry::Schema.JSON do
        required(:data).array(DEFAULT_SCHEMA)
        optional(:included).array(:hash)
      end
    end
  end
end
