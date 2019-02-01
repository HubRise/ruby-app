class HubriseApp::HubriseGateway
  HUBRISE_LOGIN_SCOPE = 'profile_with_email'
  HUBRISE_API_VERSION = :v1

  class << self
    def build_api_client(params = {})
      Hubrise::APIClientsFactory.build(
        HubriseApp::CONFIG[:hubrise_client_id],
        HubriseApp::CONFIG[:hubrise_client_secret],
        HUBRISE_API_VERSION,
        params.merge(
          oauth_host: HubriseApp::CONFIG[:hubrise_oauth_host],
          oauth_port: HubriseApp::CONFIG[:hubrise_oauth_port],
          api_host:   HubriseApp::CONFIG[:hubrise_api_host],
          api_port:   HubriseApp::CONFIG[:hubrise_api_port],
          use_https:  HubriseApp::CONFIG[:hubrise_use_https],
        )
      )
    end

    def build_api_client_from_authorization_code(authorization_code)
      build_api_client.tap do |api_client|
        api_client.authorize!(authorization_code)
      end
    end

    def build_login_authorization_url(redirect_uri)
      build_api_client.build_authorization_url(redirect_uri, HUBRISE_LOGIN_SCOPE)
    end

    def build_app_authorization_url(hr_app_instance_id, redirect_uri)
      build_api_client.build_authorization_url(redirect_uri, nil, app_instance_id: hr_app_instance_id)
    end
  end
end
