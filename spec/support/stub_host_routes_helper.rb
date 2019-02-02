module StubHostControllerUrlHelpers
  def stub_host_app_url_helpers
    HubriseApp::ApplicationController.include(HostAppUrlHelpers)
  end

  module HostAppUrlHelpers
    def hubrise_oauth_login_callback_url
      "http://hubrise_oauth_login_callback_url"
    end

    def hubrise_oauth_authorize_callback_url
      "http://hubrise_oauth_authorize_callback_url"
    end

    def hubrise_open_path
      "/hubrise_open_path"
    end
  end
end
