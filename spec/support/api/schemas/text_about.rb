module Api
  module Schemas
    class TextAbout < ApplicationSchema
      ABOUT = Dry::Schema.Params do
        required(:id).filled(:string)
        required(:type).filled(:string)
        required(:attributes).hash do
          required(:body).filled(:string)
        end
      end

      SINGLE_SCHEMA = Dry::Schema.JSON do
        required(:data).hash(ABOUT)
      end
    end
  end
end
