require_relative "./../support/api_fixtures"

FactoryBot.define do
  factory :customer_list, class: CustomerList do
    hr_id { generate_ref }
    api_data { ApiFixtures.customer_list_json.except("id") }
    refreshed_at { Time.now }
  end
end
