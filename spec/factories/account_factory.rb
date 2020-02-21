FactoryBot.define do
  factory :account, class: Account do
    hr_id { generate_ref }
    name { "Some Account name" }
    currency { "EUR" }
    refreshed_at { Time.now }
  end
end
