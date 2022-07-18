module Api
  module Schemas
    class User < ApplicationSchema
      USER = Dry::Schema.Params do
        required(:id).filled(:string)
        required(:type).filled(:string)
        required(:attributes).hash do
          required(:username).filled(:string)
          required(:email).filled(:string)
          required(:first_name).filled(:string)
          required(:last_name).filled(:string)
          required(:avatar).hash do
            required(:small).filled(:string)
            required(:large).filled(:string)
          end
        end
      end

      MANY_SCHEMA = Dry::Schema.JSON do
        config.validate_keys = true
        required(:data).array(USER)
      end
    end
  end
end
