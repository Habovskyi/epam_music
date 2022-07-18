CREATE TRIGGER playlists_ts_vector_public_content_trigger BEFORE INSERT OR UPDATE
        ON playlists FOR EACH ROW EXECUTE PROCEDURE fill_ts_vector_public_for_playlists();