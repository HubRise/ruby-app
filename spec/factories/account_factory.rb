FactoryBot.define do
  factory :account, class: Account do
    hr_id { generate_ref }
    name { "Some Account name" }
    refreshed_at { Time.now }
  end
end
