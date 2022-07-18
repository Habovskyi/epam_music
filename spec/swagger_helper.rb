# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      swagger: '2.0',
      info: {
        title: 'EpamMusic API',
        version: 'v1'
      },
      definitions: {
        user_sign_up: {
          type: :object,
          required: %i[email username password password_confirmation],
          properties: {
            email: { type: :string, example: 'email@mail.com' },
            username: { type: :string, example: 'Username' },
            password: { type: :string, example: 'sTroNgPa$$Word' },
            password_confirmation: { type: :string, example: 'sTroNgPa$$Word' },
            first_name: { type: :string, example: 'John' },
            last_name: { type: :string, example: 'Doe' }
          }
        },
        home_users: {
          type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                '$ref': '#/definitions/user'
              }
            }
          }
        },
        search_new_user: {
          type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                '$ref': '#/definitions/user'
              }
            }
          }
        },
        user: {
          type: :object,
          properties: {
            id: { type: :string },
            type: { type: :string },
            attributes: {
              type: :object,
              properties: {
                username: { type: :string },
                email: { type: :string },
                first_name: { type: :string },
                last_name: { type: :string },
                playlists_created: { type: :integer }
              }
            },
            included: { type: :object }
          }
        },
        home_playlists: {
          type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                '$ref': '#/definitions/playlist'
              }
            }
          }
        },
        playlist: Api::Schemas::Playlist::SINGLE_SCHEMA.json_schema.except(:$schema),
        public_playlists: Api::Schemas::Playlist::MANY_SCHEMA.json_schema.except(:$schema),
        friendship: Api::Schemas::Friendship::SINGLE_SCHEMA.json_schema.except(:$schema),
        list_invitations: Api::Schemas::Friendship::MANY_SCHEMA.json_schema.except(:$schema),
        friends: Api::Schemas::User::MANY_SCHEMA.json_schema.except(:$schema),
        playlist_songs: Api::Schemas::PlaylistSong::DEFAULT_SCHEMA.json_schema.except(:$schema),
        playlist_song: Api::Schemas::PlaylistSong::SINGLE_DEFAULT_SCHEMA.json_schema.except(:$schema),
        playlist_songs_shared: Api::Schemas::PlaylistSong::SHARED_SCHEMA.json_schema.except(:$schema),
        playlist_song_shared: Api::Schemas::PlaylistSong::SINGLE_SHARED_SCHEMA.json_schema.except(:$schema),
        playlist_comment: Api::Schemas::Comment::SINGLE_SCHEMA.json_schema.except(:$schema),
        list_comments: Api::Schemas::Comment::MANY_SCHEMA.json_schema.except(:$schema),
        about_text: Api::Schemas::TextAbout::SINGLE_SCHEMA.json_schema.except(:$schema),
        home_song: Api::Schemas::Song::MANY_SCHEMA.json_schema.except(:$schema),
        reaction: Api::Schemas::Reaction::SINGLE_SCHEMA.json_schema.except(:$schema),
        tokens_response: {
          type: :object,
          properties: {
            access_token: { type: :string,
                            example: 'eyJhbGciOiJIUzI1NiJ9' \
                                     '.eyJ1c2VyX2lkIjoiYTg1ZDYyZGItZmI2Yi00ZDFmLWE0YzMt' \
                                     'YWQzZWJlNzljNTA3IiwiZXhwIjoxNjUwNDQ3NTQxfQ' \
                                     '.isDdAc1Pblp-hXIgNXC_aSkmG9zHjLQrkQ7etNXFCiM' },
            refresh_token: { type: :string, example: 'eyJhbGciOiJIUzI1NiJ9' \
                                                     '.eyJ1c2VyX2lkIjoiYTg1ZDYyZGItZmI2Yi00ZDFmLWE0YzM' \
                                                     'tYWQzZWJlNzljNTA3IiwiZXhwIjoxNjUwNDQ3NTQxfQ' \
                                                     '.isDdAc1Pblp-hXIgNXC_aSkmG9zHjLQrkQ7etNXFCiM' },
            access_exp: { type: :string, example: '2022-04-19T16:45:41.429Z' },
            refresh_exp: { type: :string, example: '2022-04-20T16:15:41.429Z' }
          }
        },
        user_response: {
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string, example: 'c11319e1-7307-4ee4-a10f-51c9a888019f' },
                type: { type: :string, example: 'user' },
                attributes: {
                  type: :object,
                  properties: {
                    username: { type: :string, example: 'Testtest' },
                    email: { type: :string, example: 'email@mail.com' },
                    first_name: { type: :string, example: 'John' },
                    last_name: { type: :string, example: 'Doe' },
                    avatar: {
                      type: :object,
                      properties: {
                        large: { type: :string, example: '/uploads/store/0f798cbb8c19761601fbef6b6028aef4.png' },
                        small: { type: :string, example: '/uploads/store/f1aadd51b1c0854236d6c282d9460724.png' }
                      }
                    }
                  }
                }
              }
            }
          }
        },
        search_songs: {
          type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                '$ref': '#/definitions/song'
              }
            }
          }
        },
        song: {
          type: :object,
          properties: {
            id: { type: :string },
            type: { type: :string },
            attributes: {
              type: :object,
              properties: {
                title: { type: :string }
              }
            },
            relationships: {
              type: :object,
              properties: {
                author: { type: :object },
                album: { type: :object },
                genre: { type: :object }
              }
            },
            included: { type: :object }
          }
        }
      },
      securityDefinitions: {
        Bearer: {
          description: 'Bearer token',
          type: :apiKey,
          name: 'Authorization',
          in: :header
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.swagger_format = :yaml
end
