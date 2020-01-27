module HubriseApp::OauthController::ActionLoginCallback
  def login_callback
    hr_user = HubriseApp::Refresher::User.run(api_client_from_oauth_code)
    login(hr_user)
    redirect_to(build_hubrise_open_url)
  end
end
