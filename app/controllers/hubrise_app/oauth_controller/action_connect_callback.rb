module HubriseApp::OauthController::ActionConnectCallback
  def connect_callback
    @hr_app_instance = HubriseApp::Services.connect_app_instance.run(api_client_from_oauth_code, self)

    if logged_in?
      HubriseApp::Services.assign_app_instance.run(current_hr_user, @hr_app_instance, self)
      redirect_to(build_hubrise_open_url)
    else
      redirect_to(build_hubrise_oauth_login_url)
    end
  end
end
