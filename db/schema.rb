# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_06_29_125058) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "abouts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "albums", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nickname"], name: "index_authors_on_nickname", unique: true
  end

  create_table "comments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "playlist_id", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_comments_on_playlist_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "flipper_features", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", force: :cascade do |t|
    t.string "feature_key", null: false
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "friendships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_from_id"
    t.uuid "user_to_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_from_id"], name: "index_friendships_on_user_from_id"
    t.index ["user_to_id"], name: "index_friendships_on_user_to_id"
  end

  create_table "genres", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "playlist_songs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "playlist_id", null: false
    t.uuid "song_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id", "song_id"], name: "index_playlist_songs_on_playlist_id_and_song_id", unique: true
    t.index ["playlist_id"], name: "index_playlist_songs_on_playlist_id"
    t.index ["song_id"], name: "index_playlist_songs_on_song_id"
    t.index ["user_id"], name: "index_playlist_songs_on_user_id"
  end

  create_table "playlists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "title"
    t.text "logo_data"
    t.integer "visibility", default: 0
    t.boolean "featured", default: false
    t.datetime "deleted_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.tsvector "ts_vector_public"
    t.index ["title"], name: "index_playlists_on_title"
    t.index ["ts_vector_public"], name: "playlists_ts_vector_public_idx", using: :gin
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "reactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "playlist_id", null: false
    t.integer "reaction_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_reactions_on_playlist_id"
    t.index ["user_id"], name: "index_reactions_on_user_id"
  end

  create_table "songs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.uuid "album_id"
    t.uuid "genre_id", null: false
    t.uuid "author_id", null: false
    t.boolean "featured", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.tsvector "ts_search_vector"
    t.integer "count_listening", default: 0
    t.index ["album_id"], name: "index_songs_on_album_id"
    t.index ["author_id"], name: "index_songs_on_author_id"
    t.index ["genre_id"], name: "index_songs_on_genre_id"
    t.index ["ts_search_vector"], name: "index_songs_on_ts_search_vector", using: :gin
  end

  create_table "statistics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "new_users", default: 0, null: false
    t.integer "new_deleted_users", default: 0, null: false
    t.integer "new_playlists", default: 0, null: false
    t.integer "new_deleted_playlists", default: 0, null: false
    t.integer "new_playlist_songs", default: 0, null: false
    t.integer "new_friendships", default: 0, null: false
    t.integer "new_accepted_friendships", default: 0, null: false
    t.integer "new_songs", default: 0, null: false
    t.integer "new_genres", default: 0, null: false
    t.integer "new_authors", default: 0, null: false
    t.integer "total_users", default: 0, null: false
    t.integer "total_deleted_users", default: 0, null: false
    t.integer "total_playlists", default: 0, null: false
    t.integer "total_songs", default: 0, null: false
    t.integer "total_genres", default: 0, null: false
    t.integer "total_authors", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.integer "playlists_created", default: 0
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.text "avatar_data"
    t.tsvector "ts_search_vector"
    t.index ["email"], name: "unique_emails", unique: true
    t.index ["ts_search_vector"], name: "index_users_on_ts_search_vector", using: :gin
    t.index ["username"], name: "unique_usernames", unique: true
  end

  create_table "whitelisted_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "crypted_token"
    t.timestamptz "expiration"
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crypted_token"], name: "index_whitelisted_tokens_on_crypted_token", using: :hash
    t.index ["user_id"], name: "index_whitelisted_tokens_on_user_id"
  end

  add_foreign_key "comments", "playlists"
  add_foreign_key "comments", "users"
  add_foreign_key "friendships", "users", column: "user_from_id"
  add_foreign_key "friendships", "users", column: "user_to_id"
  add_foreign_key "playlist_songs", "playlists"
  add_foreign_key "playlist_songs", "songs"
  add_foreign_key "playlist_songs", "users"
  add_foreign_key "playlists", "users"
  add_foreign_key "reactions", "playlists"
  add_foreign_key "reactions", "users"
  add_foreign_key "songs", "albums"
  add_foreign_key "songs", "authors"
  add_foreign_key "songs", "genres"
  add_foreign_key "whitelisted_tokens", "users"
  create_function :fill_ts_vector_public_for_playlists, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.fill_ts_vector_public_for_playlists()
       RETURNS trigger
       LANGUAGE plpgsql
      AS $function$
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
        $function$
  SQL
  create_function :fill_ts_search_vector_for_songs, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.fill_ts_search_vector_for_songs()
       RETURNS trigger
       LANGUAGE plpgsql
      AS $function$
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
            $function$
  SQL
  create_function :fill_ts_search_vector_for_users, sql_definition: <<-'SQL'
      CREATE OR REPLACE FUNCTION public.fill_ts_search_vector_for_users()
       RETURNS trigger
       LANGUAGE plpgsql
      AS $function$
            begin
                new.ts_search_vector := setweight(to_tsvector('pg_catalog.english', coalesce(new.email, '')), 'A');
                return new;
            end
            $function$
  SQL


  create_trigger :users_ts_search_vector_content_trigger, sql_definition: <<-SQL
      CREATE TRIGGER users_ts_search_vector_content_trigger BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION fill_ts_search_vector_for_users()
  SQL
  create_trigger :playlists_ts_vector_public_content_trigger, sql_definition: <<-SQL
      CREATE TRIGGER playlists_ts_vector_public_content_trigger BEFORE INSERT OR UPDATE ON public.playlists FOR EACH ROW EXECUTE FUNCTION fill_ts_vector_public_for_playlists()
  SQL
  create_trigger :songs_ts_search_vector_content_trigger, sql_definition: <<-SQL
      CREATE TRIGGER songs_ts_search_vector_content_trigger BEFORE INSERT OR UPDATE ON public.songs FOR EACH ROW EXECUTE FUNCTION fill_ts_search_vector_for_songs()
  SQL
end
