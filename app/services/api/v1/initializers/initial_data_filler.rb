module Api
  module V1
    module Initializers
      class InitialDataFiller < ApplicationService
        include FactoryBot::Syntax::Methods
        ADMIN_DATA = { admin_email: 'admin@example.com', admin_pass: 'password' }.freeze
        ENTITIES = { user: rand(100..135),   friendship: rand(25..35), author: rand(15..20),   album: rand(15..25),
                     genre: rand(7..10),     song: rand(400..600),     playlist: rand(20..25), comment: rand(15..25),
                     reaction: rand(20..25), playlist_song: rand(30..50) }.freeze
        MODELS = %i[user author album genre].freeze

        def initialize(options)
          @entities_count = ENTITIES.keys.to_h do |entity|
            value = options["#{entity}_count".to_sym]
            count = value || ENTITIES[entity]
            [entity, count]
          end
        end

        def call
          MODELS.each { |model| create_list(model, @entities_count[model]) }
          create_admin
          create_friendship
          create_songs
          create_playlists
          create(:about)
        end

        private

        def create_admin
          return if Rails.env.production?

          ::AdminUser.create!(email: ADMIN_DATA[:admin_email], password: ADMIN_DATA[:admin_pass],
                              password_confirmation: ADMIN_DATA[:admin_pass])
        end

        def create_friendship
          @entities_count[:friendship].times do
            user_from = random_entity(::User)
            user_to = random_entity(::User)
            friendship = ::Friendship.new(user_from:, user_to:, status: rand(0..2))

            friendship.valid? ? friendship.save : redo
          end
        end

        def create_songs
          @entities_count[:song].times do
            author = random_entity(::Author)
            album = random_entity(::Album)
            genre = random_entity(::Genre)
            create(:song, author:, album:, genre:)
          end
        end

        def create_playlists
          @entities_count[:playlist].times do
            user = random_entity(::User)
            playlist = create(:playlist, user:, created_at: FFaker::Time.between(2.months.ago, 1.day.ago))
            create_playlists_songs(playlist, user)
            create_comments(playlist)
            create_reactions(playlist)
          end
        end

        def create_comments(playlist)
          @entities_count[:comment].times do
            user = random_entity(::User)
            comment = ::Comment.new(user:, playlist:, text: :comment)

            comment.valid? ? comment.save : redo
          end
        end

        def create_reactions(playlist)
          while ::Reaction.count < @entities_count[:reaction] * ::Playlist.count
            reaction_user = random_entity(::User)
            next if ::Reaction.where(user: reaction_user, playlist:).exists?

            create(:reaction, user: reaction_user, playlist:)
          end
        end

        def create_playlists_songs(playlist, user)
          random_offset = rand(0..ENTITIES[:playlist])
          @entities_count[:playlist_song].times do |i|
            song = nth_record(i + random_offset, ::Song)
            user = random_entity(::User)
            ::PlaylistSong.create(user:, playlist:, song:)
          end
        end

        def random_entity(scope)
          scope.order('RANDOM()').first
        end

        def nth_record(num, model)
          model.order(:id).offset(num % model.count).limit(1).first
        end
      end
    end
  end
end
