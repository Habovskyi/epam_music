source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.2', '>= 7.0.2.4'

gem 'api-pagination', '~> 5.0.0'

# Use to upload files to AWS S3
gem 'aws-sdk-s3', '~> 1.112'

gem 'decouplio', '~> 1.0.0alpha2'

gem 'flipper', '~> 0.25.0'

gem 'flipper-active_record', '~> 0.25.0'

gem 'flipper-ui', '~> 0.25.0'

gem 'newrelic_rpm', '~> 8.8.0'

# Use postgresql as the database for Active Record
gem 'pagy', '~> 5.10.1'

gem 'pg', '~> 1.1'

gem 'pg_search', '~> 2.3.6'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.6', '>= 5.6.4'

gem 'psych', '~> 3.2'

# Use to upload files
gem 'shrine', '~> 3.4'

gem 'sidekiq', '~> 6.4'

gem 'sidekiq-cron', '~> 1.3'

# Use to authorization
gem 'action_policy', '~> 0.6.0'

gem 'fast_jsonapi', '~> 1.5'

gem 'lefthook', '~> 0.7.7'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'haml-rails', '~> 2.0'

gem 'jsbundling-rails', '~> 1.0.2'

gem 'rollbar', '~> 3.3'

gem 'rspec-rails', '~> 6.0.0.rc1'

gem 'rswag', '~> 2.5'

gem 'strong_migrations', '~> 0.8.0'

gem 'fx', '~> 0.7.0'

gem 'jwt', '~> 2.3.0'

# User for secure mime-type determination
gem 'marcel', '~> 1.0.2'
# gem 'fastimage', '~> 1.8'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.12'

gem 'reform', '~> 2.6.0'

gem 'reform-rails', '~> 0.2.3'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

# Admin Panel
gem 'activeadmin', '~> 2.11.1'
gem 'devise', '~> 4.8.1'
gem 'sass-rails', '~> 6.0.0'
gem 'sprockets', '<4'

gem 'factory_bot_rails', '~> 6.2'
gem 'ffaker', '~> 2.20'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'brakeman', '~> 5.2'
  gem 'bullet', '~> 7.0'
  gem 'bundler-audit', '~> 0.9.0'
  gem 'bundler-leak', '~> 0.2.0'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dry-schema', '~> 1.9.1'
  gem 'mini_magick', '~> 4.11'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rswag-specs', '~> 2.5', '>= 2.5.1'
  gem 'rubocop', '~> 1.25'
  gem 'rubocop-performance', '~> 1.13'
  gem 'rubocop-rails', '~> 2.13'
  gem 'rubocop-rspec', '~> 2.8'
  gem 'seedbank', '~> 0.5.0'
  gem 'traceroute', '~> 0.8.1'
end

group :development do
  gem 'letter_opener', '~> 1.8.1'
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem 'json_matchers', '~> 0.11.1'
  gem 'rails-controller-testing', '~> 1.0.1'
  gem 'shoulda-matchers', '~> 5.1'
  gem 'simplecov', '~> 0.21.2', require: false
end
