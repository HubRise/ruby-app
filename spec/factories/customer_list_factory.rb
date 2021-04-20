require_relative "./../support/api_fixtures"

FactoryBot.define do
  factory :catalog, class: Catalog do
    hr_id { generate_ref }
    api_data { ApiFixtures.catalog_json.except("id") }
    refreshed_at { Time.now }
  end
end
