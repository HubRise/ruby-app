# frozen_string_literal: true
FactoryBot.define do
  factory :user, class: User do
    hr_id { generate_ref }
    refreshed_at { Time.now }
    access_token { "access_tokenX" }
    locales { ["en-GB"] }
  end
end
