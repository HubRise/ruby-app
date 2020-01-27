class HubriseApp::Refresher::User
  REFRESH_THRESHOLD = 1.day

  class << self
    def run(api_client)
      api_data = api_client.get_user.data
      HubriseApp::HrUser.find_or_initialize_by(hr_id: api_data.delete("id")).tap do |hr_user|
        hr_user.update!(
          refreshed_at: Time.now,
          hr_api_data: api_data,
          hr_access_token: api_client.access_token
        )
      end
    end
  end
end
