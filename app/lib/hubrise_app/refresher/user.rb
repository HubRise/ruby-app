class HubriseApp::Refresher::User
  REFRESH_THRESHOLD = 1.day

  class << self
    def run(api_client)
      api_data = api_client.get_user.data
      User.find_or_initialize_by(hr_id: api_data["id"]).tap do |user|
        user.update!(
          refreshed_at: Time.now,
          access_token: api_client.access_token,
          email: api_data["email"],
          first_name: api_data["first_name"],
          last_name: api_data["last_name"],
          locales: api_data["locales"]
        )
      end
    end
  end
end
