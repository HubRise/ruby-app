module HubriseApp::OauthController::ActionLoginCallback
  def login_callback
    user = HubriseApp::Refresher::User.from_api_client(api_client_from_oauth_code)
    login(user)
    redirect_to(build_hubrise_open_url)
  end
end
