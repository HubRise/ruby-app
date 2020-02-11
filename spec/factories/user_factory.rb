FactoryBot.define do
  factory :user, class: User do
    hr_id { generate_ref }
    api_data { {} }
    refreshed_at { Time.now }
    access_token { with_ref("x_profile_access_token") }
  end
end
