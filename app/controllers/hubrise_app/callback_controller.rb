module HubriseApp
  class CallbackController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :ensure_app_instance_found!
    before_action :verify_event!, only: :event

    include ActionEvent
    include ActionDisconnect

    protected

    def current_app_instance
      HubriseApp::Services::ResolveAppInstance.run(AppInstance, params[:app_instance_id], self)
    end

    def ensure_app_instance_found!
      head(404) unless current_app_instance
    end

    def event_params
      params.require(:callback).permit!.to_h
    end

    def verify_event!
      unless hubrise_gateway.valid_hmac?(request.raw_post,
                                         request.headers["X-Hubrise-Hmac-Sha256"])
        render(plain: "Invalid HubRise HMAC", status: 401)
      end
    end
  end
end
