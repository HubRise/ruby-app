module HubriseApp
  class OauthController < ApplicationController
    before_action :ensure_authenticated!, only: :authorize_callback

    def login_callback
      hr_user = HrUser.refresh_or_create_via_api_client(api_client_from_oauth_code)
      login(hr_user)
      redirect_to(main_app.hubrise_open_path)
    end

    def connect_callback
      @hr_app_instance = HrAppInstance.refresh_or_create_via_api_client(api_client_from_oauth_code)

      Services::ConnectAppInstance.run(current_hr_app_instance, hubrise_callback_event_url: hubrise_callback_event_url)

      if logged_in?
        current_hr_user.assign_hr_app_instance(current_hr_app_instance)
        redirect_to(main_app.hubrise_open_path)
      else
        redirect_to(build_hubrise_oauth_login_url)
      end
    end

    # authorize access to specific app_instance (expirable)
    def authorize_callback
      if current_hr_app_instance
        current_hr_user.assign_hr_app_instance(current_hr_app_instance)
        redirect_to(main_app.hubrise_open_path)
      else
        render(plain: "Something went wrong. Please try to reinstall the app")
      end
    end

    protected

    def current_hr_app_instance
      @hr_app_instance ||= HrAppInstance.where(hr_id: api_client_from_oauth_code.app_instance_id).take
    end

    def api_client_from_oauth_code
      @api_client_from_oauth_code ||= main_hubrise_gateway.build_api_client_from_authorization_code(params[:code])
    end
  end
end
