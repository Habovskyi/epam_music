CREATE OR REPLACE FUNCTION fill_ts_search_vector_for_users() RETURNS trigger
    LANGUAGE plpgsql AS
      $$
      begin
          new.ts_search_vector := setweight(to_tsvector('pg_catalog.english', coalesce(new.email, '')), 'A');
          return new;
      end
      $$