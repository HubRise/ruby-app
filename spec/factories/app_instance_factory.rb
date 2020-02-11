FactoryBot.define do
  factory :app_instance, class: AppInstance do
    hr_id { generate_ref }
    access_token { "x_app_access_token" }
  end
end
