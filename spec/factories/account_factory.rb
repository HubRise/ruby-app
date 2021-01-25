FactoryBot.define do
  factory :account, class: Account do
    hr_id { generate_ref }
    api_data { { "currency" => "EUR", "name" => "Some Account name" } }
    refreshed_at { Time.now }
  end
end
