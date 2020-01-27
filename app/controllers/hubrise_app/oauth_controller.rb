module HubriseApp
  class OauthController < ApplicationController
    before_action :ensure_authenticated!, only: :authorize_callback

    def login_callback
      hr_user = HubriseApp::Refresher::User.run(api_client_from_oauth_code)
      login(hr_user)
      redirect_to(build_hubrise_open_url)
    end

    def connect_callback
      @hr_app_instance = HubriseApp::Services.connect_app_instance.run(api_client_from_oauth_code, self)

      if logged_in?
        current_hr_user.assign_hr_app_instance(@hr_app_instance)
        redirect_to(build_hubrise_open_url)
      else
        redirect_to(build_hubrise_oauth_login_url)
      end
    end

    # authorize access to specific app_instance (expirable)
    def authorize_callback
      if current_hr_app_instance
        current_hr_user.assign_hr_app_instance(current_hr_app_instance)
        redirect_to(build_hubrise_open_url)
      else
        render(plain: "Something went wrong. Please try to reinstall the app")
      end
    end

    protected

    def current_hr_app_instance
      @hr_app_instance ||= HubriseApp::Services.resolve_app_instance.run(HrAppInstance, api_client_from_oauth_code.app_instance_id, self)
    end

    def api_client_from_oauth_code
      @api_client ||= hubrise_gateway.build_api_client_from_authorization_code(params[:code])
    end
  end
end
