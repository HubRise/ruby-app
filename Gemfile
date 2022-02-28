source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

group :test do
  gem "factory_bot_rails"
  gem "mysql2", ">= 0.4.4", "< 0.6.0"
  gem "pry-rails"
  gem "rspec-rails"
  gem "webmock"
end

group :development do
  gem "rubocop"
end
