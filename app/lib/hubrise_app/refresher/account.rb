class HubriseApp::Refresher::Account
  REFRESH_THRESHOLD = 1.day

  class << self
    def run(account, api_client)
      return unless stale?(account)
      raise if api_client.account_id != account.hr_id

      account.update!(
        refreshed_at: Time.now,
        api_data: if api_client.location_id
                       api_client.get_location(api_client.location_id).data["account"]
                     else
                       api_client.get_account(account.hr_id).data
                     end.except("id")
      )
    end

    def stale?(account)
      account.refreshed_at.nil? || Time.now - account.refreshed_at > REFRESH_THRESHOLD
    end
  end
end
