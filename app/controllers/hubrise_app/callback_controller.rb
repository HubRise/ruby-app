module HubriseApp
  class CallbackController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :ensure_hr_app_instance_found!

    include ActionEvent
    include ActionDisconnect

    protected

    def current_hr_app_instance
      HubriseApp::Services::ResolveAppInstance.run(HrAppInstance, params[:app_instance_id], self)
    end

    def ensure_hr_app_instance_found!
      head(404) unless current_hr_app_instance
    end

    def event_params
      params.permit!.to_h.except(:controller, :action)
    end
  end
end
