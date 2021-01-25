FactoryBot.define do
  factory :location, class: Location do
    hr_id { generate_ref }
    api_data { { "name" => "Some Location name", "timezone" => { "name" => "Europe/London" } } }
    refreshed_at { Time.now }
  end
end
