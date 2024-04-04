# frozen_string_literal: true
module HubriseApp
  class OauthController < ApplicationController
    include ActionLoginCallback
    include ActionConnectCallback
    include ActionAuthorizeCallback

    protected

    def current_app_instance
      @app_instance ||= HubriseApp::Services::ResolveAppInstance.run(
        AppInstance, api_client_from_oauth_code.app_instance_id, self
      )
    end

    def api_client_from_oauth_code
      @api_client ||= hubrise_gateway.build_api_client_from_authorization_code(params[:code])
    end
  end
end
