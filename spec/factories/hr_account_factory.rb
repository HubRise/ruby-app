FactoryBot.define do
  factory :hr_account, class: HubriseApp::HrAccount do
    hr_id { generate_ref }
    hr_api_data { Hash.new }
    refreshed_at { Time.now }
  end
end