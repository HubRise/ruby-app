FactoryBot.define do
  factory :hr_user, class: HubriseApp::HrUser do
    hr_id { generate_ref }
    hr_api_data { Hash.new }
    refreshed_at { Time.now }
    hr_access_token { with_ref("x_profile_access_token") }
  end
end