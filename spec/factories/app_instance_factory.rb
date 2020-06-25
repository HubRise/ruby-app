FactoryBot.define do
  factory :app_instance, class: AppInstance do
    hr_id { generate_ref }
    access_token { "x_app_access_token" }

    transient do
      user { nil }
    end

    after(:create) do |app_instance, evaluator|
      if evaluator.user
        evaluator.user.user_app_instances.create!(hr_app_instance_id: app_instance.hr_id, refreshed_at: Time.now)
      end
    end
  end
end
