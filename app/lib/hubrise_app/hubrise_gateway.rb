class HubriseApp::HubriseGateway
  HUBRISE_LOGIN_SCOPE = "profile_with_email".freeze

  def initialize(config = HubriseApp::CONFIG)
    @config = config
  end

  def build_api_client(params = {})
    HubriseClient::V1.new(
      @config[:hubrise_client_id],
      @config[:hubrise_client_secret],
      params.merge(
        oauth_host: @config[:hubrise_oauth_host],
        oauth_port: @config[:hubrise_oauth_port],
        api_host: @config[:hubrise_api_host],
        api_port: @config[:hubrise_api_port],
        use_https: @config[:hubrise_use_https]
      )
    )
  end

  def build_api_client_from_app_instance(app_instance)
    build_api_client(
      access_token: app_instance.hr_access_token,
      app_instance_id: app_instance.hr_id,
      account_id: app_instance.hr_account_id,
      location_id: app_instance.hr_location_id,
      catalog_id: app_instance.hr_catalog_id,
      customer_list_id: app_instance.hr_customer_list_id
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
