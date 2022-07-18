# rubocop:disable all
require 'optparse'
require 'ffaker'

namespace :data do
    desc 'fill in data into dev and test databases'

  task :create,    %i[user_count
                   friendship_count
                   author_count
                   album_count
                   genre_count
                   song_count
                   playlist_count
                   comment_count
                   reaction_count
                   playlist_song_count
                   ] => :environment do |_t, args|

    unless Rails.env.production?
      Rake::Task['db:reset'].invoke
    end

    options = {}
    opts = OptionParser.new

    opts.banner = "Usage: rake add [options]"

    opts.on("--user_count ARG", Integer) { |user_count| options[:user_count] = user_count }
    opts.on("--friendship_count ARG", Integer) { |friendship_count| options[:friendship_count] = friendship_count }
    opts.on("--author_count ARG", Integer) { |author_count| options[:author_count] = author_count }
    opts.on("--album_count ARG", Integer) { |album_count| options[:album_count] = album_count }
    opts.on("--genre_count ARG", Integer) { |genre_count| options[:genre_count] = genre_count }
    opts.on("--song_count ARG", Integer) { |song_count| options[:song_count] = song_count }
    opts.on("--playlist_count ARG", Integer) { |playlist_count| options[:playlist_count] = playlist_count }
    opts.on("--comment_count ARG", Integer) { |comment_count| options[:comment_count] = comment_count }
    opts.on("--reaction_count ARG", Integer) { |reaction_count| options[:reaction_count] = reaction_count }
    opts.on("--playlist_song_count ARG", Integer) { |playlist_song_count| options[:playlist_song_count] = playlist_song_count }
    args = opts.order!(ARGV) {}
    opts.parse!(args)

    Api::V1::Initializers::InitialDataFiller.call(options)

    puts 'Thank you for the waiting. Your objects are ready to use.'
    exit
  end
end
# rubocop:enable all
