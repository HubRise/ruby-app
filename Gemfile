source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gemspec

gem "hubrise_ruby_lib", git: "https://github.com/hubrise/hubrise_ruby_lib.git", tag: "v0.0.20"

group :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "webmock"
  gem "database_cleaner"
end