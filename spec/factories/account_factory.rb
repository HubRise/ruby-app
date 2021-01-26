FactoryBot.define do
  factory :account, class: Account do
    hr_id { generate_ref }
    api_data { ApiFixtures.account_json.except("id") }
    refreshed_at { Time.now }
  end
end
