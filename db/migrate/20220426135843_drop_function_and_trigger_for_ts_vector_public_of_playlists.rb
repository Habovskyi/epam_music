# rubocop:disable Metrics/MethodLength, Metrics/BlockLength
class DropFunctionAndTriggerForTsVectorPublicOfPlaylists < ActiveRecord::Migration[7.0]
  def self.up
    safety_assured do
      execute <<-SQL.squish
        DROP FUNCTION fill_ts_vector_public_for_playlists() CASCADE;
      SQL
    end
  end

  def self.down
    safety_assured do
      execute <<-SQL.squish
      CREATE OR REPLACE FUNCTION fill_ts_vector_public_for_playlists() RETURNS trigger
      LANGUAGE plpgsql AS
        $$
        declare
            playlist_owner record;
            songs_titles   record;
            songs_authors  record;

        begin
            select username into playlist_owner from users where id = new.user_id;
      #{'  '}
            select songs.title
            into songs_titles
            from (select playlist_songs.playlist_id as playlist_id, songs.title as title
                  from playlist_songs
                           left join songs on playlist_songs.song_id = songs.id) as songs
            where new.id = songs.playlist_id;
      #{'      '}
            select songs.author
            into songs_authors
            from (select playlist_songs.playlist_id as playlist_id, songs.nickname as author
                  from playlist_songs
                           left join (select songs.id, a.nickname as nickname
                                      from songs
                                               left join authors a on songs.author_id = a.id) as songs
                                     on playlist_songs.song_id = songs.id) as songs
            where new.id = songs.playlist_id;
      #{'                    '}
            new.ts_vector_public :=
                                setweight(to_tsvector('pg_catalog.english', coalesce(new.title, '')), 'A') ||
                                setweight(to_tsvector('pg_catalog.english', coalesce(new.description, '')), 'A') ||
                                setweight(to_tsvector('pg_catalog.english', coalesce(songs_titles.title, '')), 'B') ||
                                setweight(to_tsvector('pg_catalog.english', coalesce(songs_authors.author, '')), 'B') ||
                                setweight(to_tsvector('pg_catalog.english', coalesce(playlist_owner.username, '')), 'C');
            return new;
        end
        $$;
      SQL

      execute <<-SQL.squish
        CREATE TRIGGER playlists_ts_vector_public_content_trigger BEFORE INSERT OR UPDATE
          ON playlists FOR EACH ROW EXECUTE PROCEDURE fill_ts_vector_public_for_playlists();
      SQL

      Playlist.find_each(&:touch)
    end
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/BlockLength
