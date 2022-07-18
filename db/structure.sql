SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: fill_ts_vector_public_for_playlists(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fill_ts_vector_public_for_playlists() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      declare
          playlist_owner record;
          songs_titles   record;
          songs_authors  record;

      begin
          select username into playlist_owner from users where id = new.user_id;
      
          select songs.title
          into songs_titles
          from (select playlist_songs.playlist_id as playlist_id, songs.title as title
                from playlist_songs
                         left join songs on playlist_songs.song_id = songs.id) as songs
          where new.id = songs.playlist_id;
          
          select songs.author
          into songs_authors
          from (select playlist_songs.playlist_id as playlist_id, songs.nickname as author
                from playlist_songs
                         left join (select songs.id, a.nickname as nickname
                                    from songs
                                             left join authors a on songs.author_id = a.id) as songs
                                   on playlist_songs.song_id = songs.id) as songs
          where new.id = songs.playlist_id;
                        
          new.ts_vector_public :=
                              setweight(to_tsvector('pg_catalog.english', coalesce(new.title, '')), 'A') ||
                              setweight(to_tsvector('pg_catalog.english', coalesce(new.description, '')), 'A') ||
                              setweight(to_tsvector('pg_catalog.english', coalesce(songs_titles.title, '')), 'B') ||
                              setweight(to_tsvector('pg_catalog.english', coalesce(songs_authors.author, '')), 'B') ||
                              setweight(to_tsvector('pg_catalog.english', coalesce(playlist_owner.username, '')), 'C');
          return new;
      end
      $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_admin_comments (
    id bigint NOT NULL,
    namespace character varying,
    body text,
    resource_type character varying,
    resource_id bigint,
    author_type character varying,
    author_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_admin_comments_id_seq OWNED BY public.active_admin_comments.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: albums; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.albums (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: authors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.authors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    nickname character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    playlist_id uuid NOT NULL,
    text text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: friendships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendships (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_from_id uuid,
    user_to_id uuid,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: genres; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.genres (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: playlist_songs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playlist_songs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    playlist_id uuid NOT NULL,
    song_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: playlists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playlists (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    title character varying,
    logo_data text,
    visibility integer DEFAULT 0,
    featured boolean DEFAULT false,
    deleted_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    description text,
    ts_vector_public tsvector
);


--
-- Name: reactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    playlist_id uuid NOT NULL,
    reaction_type integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: songs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.songs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying,
    album_id uuid,
    genre_id uuid NOT NULL,
    author_id uuid NOT NULL,
    featured boolean DEFAULT false,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying,
    email character varying,
    first_name character varying,
    last_name character varying,
    playlists_created integer DEFAULT 0,
    active boolean DEFAULT true,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    password_digest character varying,
    avatar_data text
);


--
-- Name: active_admin_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments ALTER COLUMN id SET DEFAULT nextval('public.active_admin_comments_id_seq'::regclass);


--
-- Name: active_admin_comments active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: albums albums_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.albums
    ADD CONSTRAINT albums_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: authors authors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: friendships friendships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_pkey PRIMARY KEY (id);


--
-- Name: genres genres_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id);


--
-- Name: playlist_songs playlist_songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist_songs
    ADD CONSTRAINT playlist_songs_pkey PRIMARY KEY (id);


--
-- Name: playlists playlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT playlists_pkey PRIMARY KEY (id);


--
-- Name: reactions reactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reactions
    ADD CONSTRAINT reactions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_author ON public.active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_namespace ON public.active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_resource ON public.active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON public.admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON public.admin_users USING btree (reset_password_token);


--
-- Name: index_authors_on_nickname; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_authors_on_nickname ON public.authors USING btree (nickname);


--
-- Name: index_comments_on_playlist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_playlist_id ON public.comments USING btree (playlist_id);


--
-- Name: index_comments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_user_id ON public.comments USING btree (user_id);


--
-- Name: index_friendships_on_user_from_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendships_on_user_from_id ON public.friendships USING btree (user_from_id);


--
-- Name: index_friendships_on_user_to_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_friendships_on_user_to_id ON public.friendships USING btree (user_to_id);


--
-- Name: index_genres_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_genres_on_name ON public.genres USING btree (name);


--
-- Name: index_playlist_songs_on_playlist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playlist_songs_on_playlist_id ON public.playlist_songs USING btree (playlist_id);


--
-- Name: index_playlist_songs_on_playlist_id_and_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_playlist_songs_on_playlist_id_and_song_id ON public.playlist_songs USING btree (playlist_id, song_id);


--
-- Name: index_playlist_songs_on_song_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playlist_songs_on_song_id ON public.playlist_songs USING btree (song_id);


--
-- Name: index_playlist_songs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playlist_songs_on_user_id ON public.playlist_songs USING btree (user_id);


--
-- Name: index_playlists_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playlists_on_title ON public.playlists USING btree (title);


--
-- Name: index_playlists_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playlists_on_user_id ON public.playlists USING btree (user_id);


--
-- Name: index_reactions_on_playlist_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reactions_on_playlist_id ON public.reactions USING btree (playlist_id);


--
-- Name: index_reactions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reactions_on_user_id ON public.reactions USING btree (user_id);


--
-- Name: index_songs_on_album_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_songs_on_album_id ON public.songs USING btree (album_id);


--
-- Name: index_songs_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_songs_on_author_id ON public.songs USING btree (author_id);


--
-- Name: index_songs_on_genre_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_songs_on_genre_id ON public.songs USING btree (genre_id);


--
-- Name: playlists_ts_vector_public_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX playlists_ts_vector_public_idx ON public.playlists USING gin (ts_vector_public);


--
-- Name: unique_emails; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_emails ON public.users USING btree (email);


--
-- Name: unique_usernames; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_usernames ON public.users USING btree (username);


--
-- Name: playlists playlists_ts_vector_public_content_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER playlists_ts_vector_public_content_trigger BEFORE INSERT OR UPDATE ON public.playlists FOR EACH ROW EXECUTE FUNCTION public.fill_ts_vector_public_for_playlists();


--
-- Name: songs fk_rails_028deefde5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT fk_rails_028deefde5 FOREIGN KEY (author_id) REFERENCES public.authors(id);


--
-- Name: comments fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: playlist_songs fk_rails_282ee7fa4c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist_songs
    ADD CONSTRAINT fk_rails_282ee7fa4c FOREIGN KEY (playlist_id) REFERENCES public.playlists(id);


--
-- Name: songs fk_rails_31272893df; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT fk_rails_31272893df FOREIGN KEY (genre_id) REFERENCES public.genres(id);


--
-- Name: playlist_songs fk_rails_3e4fe7bf69; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist_songs
    ADD CONSTRAINT fk_rails_3e4fe7bf69 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: playlist_songs fk_rails_4771edc43f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist_songs
    ADD CONSTRAINT fk_rails_4771edc43f FOREIGN KEY (song_id) REFERENCES public.songs(id);


--
-- Name: reactions fk_rails_9f02fc96a0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reactions
    ADD CONSTRAINT fk_rails_9f02fc96a0 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: comments fk_rails_a1f93498c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_a1f93498c3 FOREIGN KEY (playlist_id) REFERENCES public.playlists(id);


--
-- Name: reactions fk_rails_a846387f79; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reactions
    ADD CONSTRAINT fk_rails_a846387f79 FOREIGN KEY (playlist_id) REFERENCES public.playlists(id);


--
-- Name: friendships fk_rails_abd8f017c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT fk_rails_abd8f017c3 FOREIGN KEY (user_to_id) REFERENCES public.users(id);


--
-- Name: playlists fk_rails_d67ef1eb45; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlists
    ADD CONSTRAINT fk_rails_d67ef1eb45 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: friendships fk_rails_ea1991b83d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT fk_rails_ea1991b83d FOREIGN KEY (user_from_id) REFERENCES public.users(id);


--
-- Name: songs fk_rails_f4e40cd655; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT fk_rails_f4e40cd655 FOREIGN KEY (album_id) REFERENCES public.albums(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20220318174801'),
('20220318175337'),
('20220322205034'),
('20220323083950'),
('20220323085757'),
('20220323091412'),
('20220323192006'),
('20220323192945'),
('20220324071327'),
('20220329100811'),
('20220330132919'),
('20220330204302'),
('20220405211740'),
('20220406192701'),
('20220406192704'),
('20220413174341'),
('20220414150322'),
('20220414150938');


