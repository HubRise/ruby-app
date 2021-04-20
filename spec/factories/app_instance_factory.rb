FactoryBot.define do
  factory :app_instance, class: AppInstance do
    hr_id { generate_ref }
    access_token { "access_tokenX" }

    transient do
      user { nil }
      refreshed_at { Time.now }
    end

    after(:build) do |app_instance, evaluator|
      if app_instance.hr_account_id
        app_instance.account ||= build(:account,
                                       hr_id: app_instance.hr_account_id,
                                       refreshed_at: evaluator.refreshed_at)
      end

      if app_instance.hr_location_id
        app_instance.location ||= build(:location,
                                        hr_id: app_instance.hr_location_id,
                                        refreshed_at: evaluator.refreshed_at)
      end

      if app_instance.hr_catalog_id
        app_instance.catalog ||= build(:catalog,
                                       hr_id: app_instance.hr_catalog_id,
                                       refreshed_at: evaluator.refreshed_at)
      end

      if app_instance.hr_customer_list_id
        app_instance.customer_list ||= build(:customer_list,
                                             hr_id: app_instance.hr_customer_list_id,
                                             refreshed_at: evaluator.refreshed_at)
      end
    end

    after(:create) do |app_instance, evaluator|
      if evaluator.user
        evaluator.user.user_app_instances.create!(
          hr_app_instance_id: app_instance.hr_id, refreshed_at: evaluator.refreshed_at
        )
      end
    end
  end
end
