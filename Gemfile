source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in signalman.gemspec.
gemspec

gem "puma"
gem "sqlite3"
gem "sprockets-rails"
gem "turbo-rails"
gem "importmap-rails"
gem "redis"

group :development, :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "standardrb", "~> 1.0"
  gem "debug", ">= 1.0.0"
end

group :development do
  gem "web-console"
end
