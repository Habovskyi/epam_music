module Api
  module Schemas
    class PlaylistSong < ApplicationSchema
      SONG = Dry::Schema.Params do
        required(:song).hash do
          required(:data).hash do
            required(:id).filled(:string)
            required(:type).filled(:string)
          end
        end
      end

      USER = Dry::Schema.Params do
        required(:user).hash do
          required(:data).hash do
            required(:id).filled(:string)
            required(:type).filled(:string)
          end
        end
      end

      PLAYLIST_SONG_DEFAULT = Dry::Schema.Params do
        required(:id).filled(:string)
        required(:type).filled(:string)
        required(:relationships).hash(SONG)
      end

      PLAYLIST_SONG_SHARED = Dry::Schema.Params do
        required(:id).filled(:string)
        required(:type).filled(:string)
        required(:relationships).hash(SONG & USER)
      end

      DEFAULT_SCHEMA = Dry::Schema.Params do
        config.validate_keys = true
        required(:data).array(PLAYLIST_SONG_DEFAULT)
        optional(:included).array(:hash)
      end

      SHARED_SCHEMA = Dry::Schema.Params do
        required(:data).array(PLAYLIST_SONG_SHARED)
        optional(:included).array(:hash)
      end

      SINGLE_DEFAULT_SCHEMA = Dry::Schema.Params do
        config.validate_keys = true
        required(:data).hash(PLAYLIST_SONG_DEFAULT)
        optional(:included).array(:hash)
      end

      SINGLE_SHARED_SCHEMA = Dry::Schema.Params do
        required(:data).hash(PLAYLIST_SONG_SHARED)
        optional(:included).array(:hash)
      end
    end
  end
end
