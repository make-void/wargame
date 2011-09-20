source 'http://rubygems.org'

gem 'rails', '3.0.10'

# Bundle edge Rails instead:
# gem 'rails', :git => 'https://github.com/rails/rails.git'

gem 'mysql2', '~> 0.2.11'

gem "geocoder"

gem "composite_primary_keys"
#gem "activerecord-import"

gem "haml"
gem "sass"


gem 'resque'

gem 'newrelic_rpm'

gem "voidtools", git: "https://github.com/makevoid/voidtools"

gem "exception_notification", :git => "https://github.com/rails/exception_notification"

group :development do
  gem 'rb-fsevent'
  gem 'growl'
  gem "guard"
  gem "guard-livereload"
  #gem "guard-coffeescript"
  gem 'guard-rspec'
  gem 'guard-spork'  
end

group :development, :test do
  gem "rspec-rails", "~> 2.6"
  gem "jasmine", group: [:development, :test]
  gem "spork"
end
group :test do
  gem "factory_girl_rails"
  gem "capybara"
end




# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
