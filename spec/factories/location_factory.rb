require_relative "./../support/api_fixtures"

FactoryBot.define do
  factory :location, class: Location do
    hr_id { generate_ref }
    api_data { ApiFixtures.location_json.except("id") }
    refreshed_at { Time.now }
  end
end
