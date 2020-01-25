module HubriseApp::ApplicationController::HubriseGatewayMethods
  def hubrise_gateway
    @hubrise_gateway ||= HubriseApp::HubriseGateway.new
  end

  def build_hubrise_oauth_login_url
    hubrise_gateway.build_login_authorization_url(build_hubrise_oauth_login_callback_url)
  end

  def build_hubrise_oauth_authorize_url
    hubrise_gateway.build_app_authorization_url(hr_app_instance_id, build_hubrise_oauth_authorize_callback_url)
  end

  def build_hubrise_oauth_login_callback_url
    hubrise_app.hubrise_oauth_login_callback_url
  end

  def build_hubrise_oauth_authorize_callback_url
    hubrise_app.hubrise_oauth_authorize_callback_url
  end

  def build_hubrise_open_url
    main_app.hubrise_open_path
  end
end
