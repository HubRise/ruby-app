source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem "hubrise_ruby_lib", git: "https://github.com/hubrise/ruby-lib.git", tag: "v1.0.0"

group :test do
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rspec-rails"
  gem "timecop"
  gem "webmock"
end

group :development do
  gem "rubocop"
end
