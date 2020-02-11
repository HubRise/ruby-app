class HubriseApp::Refresher::User
  REFRESH_THRESHOLD = 1.day

  class << self
    def run(api_client)
      api_data = api_client.get_user.data
      User.find_or_initialize_by(hr_id: api_data.delete("id")).tap do |user|
        user.update!(
          refreshed_at: Time.now,
          api_data: api_data,
          access_token: api_client.access_token
        )
      end
    end
  end
end
