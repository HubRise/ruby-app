FactoryBot.define do
  factory :hr_app_instance, class: HubriseApp::HrAppInstance do
    hr_id { generate_ref }
    hr_access_token { "x_app_access_token" }
  end
end
