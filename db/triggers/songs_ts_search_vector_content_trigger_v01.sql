CREATE TRIGGER songs_ts_search_vector_content_trigger BEFORE INSERT OR UPDATE
        ON songs FOR EACH ROW EXECUTE PROCEDURE fill_ts_search_vector_for_songs();