FactoryBot.define do
  factory :location, class: Location do
    hr_id { generate_ref }
    name { "Some Location name" }
    refreshed_at { Time.now }
    timezone { "Europe/London" }
  end
end
