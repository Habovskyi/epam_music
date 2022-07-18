CREATE OR REPLACE FUNCTION fill_ts_search_vector_for_songs() RETURNS trigger
    LANGUAGE plpgsql AS
      $$
      declare
          song_authors  record;
          song_albums  record;
          song_genres  record;

      begin
          select nickname into song_authors from authors where id = new.author_id;
          select title into song_albums from albums where id = new.album_id;
          select name into song_genres from genres where id = new.genre_id;
                        
          new.ts_search_vector :=
                              setweight(to_tsvector('pg_catalog.english', coalesce(new.title, '')), 'A') ||
                              setweight(to_tsvector('pg_catalog.english', coalesce(song_authors.nickname, '')), 'B') ||
                              setweight(to_tsvector('pg_catalog.english', coalesce(song_albums.title, '')), 'B') ||
                              setweight(to_tsvector('pg_catalog.english', coalesce(song_genres.name, '')), 'B');
          return new;
      end
      $$;