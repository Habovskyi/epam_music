module Api
  module Schemas
    class Playlist < ApplicationSchema
      PLAYLIST = Dry::Schema.Params do
        required(:id).filled(:string)
        required(:type).filled(:string)
        required(:attributes).hash do
          required(:title).filled(:string)
          required(:visibility).filled(:string)
          required(:featured).filled(:bool)
          required(:created_at).filled(:date)
          required(:logo).hash do
            required(:small).filled(:string)
            required(:large).filled(:string)
          end
          required(:description).filled(:string)
        end
        required(:relationships).hash do
          required(:songs).hash do
            required(:data).array(:hash)
          end
          required(:owner).hash do
            required(:data).value(:hash)
          end
        end
        required(:meta).hash do
          required(:comments_count).filled(:integer)
          required(:songs_count).filled(:integer)
          required(:likes_count).filled(:integer)
          required(:dislikes_count).filled(:integer)
        end
      end

      SINGLE_SCHEMA = Dry::Schema.JSON do
        required(:data).hash(PLAYLIST)
        optional(:included).array(:hash)
      end

      MANY_SCHEMA = Dry::Schema.JSON do
        required(:data).array(PLAYLIST)
        optional(:included).array(:hash)
      end
    end
  end
end
