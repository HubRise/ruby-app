module StubHostControllerUrlHelpers
  def strub_host_controller_url_helpers
    HubriseApp::ApplicationController.include(HostUrlHelpers)
  end

  module HostUrlHelpers
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
