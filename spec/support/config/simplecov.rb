require 'simplecov'

SimpleCov.start 'rails' do
  add_filter 'vendor'
  minimum_coverage 95
  add_group 'Queries', 'app/queries'
  add_group 'Uploaders', 'app/uploaders'
end
