module HubriseApp
  class OauthController < ApplicationController
    include ActionLoginCallback
    include ActionConnectCallback
    include ActionAuthorizeCallback

    protected

    def current_hr_app_instance
      @hr_app_instance ||= HubriseApp::Services::ResolveAppInstance.run(HrAppInstance, api_client_from_oauth_code.app_instance_id, self)
    end

    def api_client_from_oauth_code
      @api_client ||= hubrise_gateway.build_api_client_from_authorization_code(params[:code])
    end
  end
end
