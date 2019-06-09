source "https://rubygems.org"

ruby "2.5.1"

gem "rails", "~>5.2.3"
gem "pg"
gem "puma"
gem "graphql"
gem "fast_jsonapi"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors", :require => "rack/cors"

group :development, :test do
  gem "pry-rails"
  gem "dotenv-rails"
  gem "bullet"
end

group :development do
  gem "listen"
  gem "spring"
  gem "spring-watcher-listen"
  gem "rubocop-rails"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Libraries
gem "httparty"
gem "active_model_serializers"


# Security Updates
gem "loofah"
gem "nokogiri"
