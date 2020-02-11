FactoryBot.define do
  factory :location, class: Location do
    hr_id { generate_ref }
    api_data { {} }
    refreshed_at { Time.now }
  end
end
