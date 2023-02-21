require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("dummy/config/environment.rb", __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }
FactoryBot.definition_file_paths << File.expand_path("factories", __dir__)
FactoryBot.find_definitions

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include(HubriseApp::SpecSupport::HubriseHelpers)
  config.include(FactoryBot::Syntax::Methods)
  config.include(ActiveSupport::Testing::TimeHelpers)
end
