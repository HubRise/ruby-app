# frozen_string_literal: true
module HubriseApp
  module OauthController
    module ActionAuthorizeCallback
      # authorize access to specific app_instance (expirable)
      def authorize_callback
        ensure_authenticated! do
          if current_app_instance
            HubriseApp::Services::AssignAppInstance.run(current_user, current_app_instance, self)
            redirect_to(build_hubrise_open_url)
          else
            render(plain: "Something went wrong. Please try to reinstall the app")
          end
        end
      end
    end
  end
end
