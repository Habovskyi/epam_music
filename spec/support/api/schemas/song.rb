module Api
  module Schemas
    class Song < ApplicationSchema
      SONG = Dry::Schema.Params do
        required(:id).filled(:string)
        required(:type).filled(:string)
        required(:attributes).hash do
          required(:title).filled(:string)
          required(:count_listening).filled(:integer)
          required(:created_at).filled(:date)
        end
        required(:relationships).hash do
          required(:genre).hash do
            required(:data).array(:hash) do
              required(:id).filled(:string)
              required(:type).filled(:string)
            end
          end
        end
      end

      MANY_SCHEMA = Dry::Schema.JSON do
        required(:data).array(SONG)
        optional(:included).array(:hash)
      end
    end
  end
end
