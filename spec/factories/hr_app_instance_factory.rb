FactoryBot.define do
  factory :hr_app_instance, class: HubriseApp::HrAppInstance do
    hr_id { generate_ref }
    hr_access_token  { "x_app_access_token" }

    trait(:catalog)       { hr_catalog_id { generate_ref } }
    trait(:customer_list) { hr_customer_list_id { generate_ref } }
    trait(:account) do
      hr_account_id do
        HubriseApp::HrAccount.create!(
          hr_id:        generate_ref,
          hr_api_data:  Hash.new,
          refreshed_at: Time.now,
        ).hr_id
      end
    end
    trait(:location) do
      hr_location_id do
        HubriseApp::HrLocation.create!(
          hr_id:        generate_ref,
          hr_api_data:  Hash.new,
          refreshed_at: Time.now,
        ).hr_id
      end
    end
  end
end