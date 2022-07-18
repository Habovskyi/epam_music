CREATE TRIGGER users_ts_search_vector_content_trigger BEFORE INSERT OR UPDATE
        ON users FOR EACH ROW EXECUTE PROCEDURE fill_ts_search_vector_for_users();