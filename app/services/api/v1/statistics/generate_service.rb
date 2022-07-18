module Api
  module V1
    module Statistics
      class GenerateService < ApplicationService
        def initialize(time_period = nil)
          @time_period = time_period&.ago
        end

        def call
          @statistic = Statistic.new
          init_last_statistic
          fill_statistic
          [@statistic, @last_statistic]
        end

        private

        def fill_statistic
          @statistic.update!(total_records_attributes.merge(new_records_attributes, deleted_records_attributes))
        end

        def new_records_attributes
          @new_records_attributes ||= {
            new_users: new_records_count(:users),
            new_playlists: new_records_count(:playlists),
            new_playlist_songs: last_records_count(::PlaylistSong),
            new_friendships: last_records_count(::Friendship),
            new_accepted_friendships: last_records_count(::Friendship.accepted),
            new_songs: new_records_count(:songs),
            new_genres: new_records_count(:genres),
            new_authors: new_records_count(:authors)
          }
        end

        def deleted_records_attributes
          @deleted_records_attributes ||= {
            new_deleted_users: new_records_count(:deleted_users),
            new_deleted_playlists: last_records_count(::Playlist, deleted: true)
          }
        end

        def total_records_attributes
          @total_records_attributes ||= {
            total_users: ::User.active.count,
            total_deleted_users: last_records_count(::User.inactive) + last_statistic_count('total_deleted_users'),
            total_playlists: ::Playlist.active.count,
            total_songs: ::Song.count,
            total_genres: ::Genre.count,
            total_authors: ::Author.count
          }
        end

        def init_last_statistic
          model = ::Statistic
          model = model.where('created_at >= ?', @time_period) unless @time_period.nil?
          @last_statistic = model.order(:created_at).last
        end

        def new_records_count(attr)
          total_records_attributes["total_#{attr}".to_sym] - last_statistic_count("total_#{attr}")
        end

        def last_statistic_count(attr)
          return 0 if @last_statistic.nil?

          @last_statistic.attributes[attr]
        end

        def last_records_count(model, deleted: false)
          model = model.where("#{deleted ? 'deleted_at' : 'created_at'} > ?", @time_period) unless @time_period.nil?
          model.count
        end
      end
    end
  end
end
