# frozen_string_literal: true
module HubriseApp
  class OauthController
    module ActionConnectCallback
      def connect_callback
        @app_instance = HubriseApp::Services::ConnectAppInstance.run(api_client_from_oauth_code, self)

        if logged_in?
          HubriseApp::Services::AssignAppInstance.run(current_user, @app_instance, self)
          redirect_to(build_hubrise_open_url)
        else
          redirect_to(build_hubrise_oauth_login_url, allow_other_host: true)
        end
      end
    end
  end
end
