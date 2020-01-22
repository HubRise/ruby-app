module HubriseApp
  class CallbackController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :ensure_hr_app_instance_found!

    def event
      Services.handle_event.run(current_hr_app_instance, params.permit!.to_h, self)
      head 200
    end

    def disconnect
      Services.disconnect_app_instance.run(current_hr_app_instance, self)
      head 200
    end

    protected

    def current_hr_app_instance
      HubriseApp::Services.resolve_app_instance.run(HrAppInstance, params[:app_instance_id], self)
    end

    def ensure_hr_app_instance_found!
      head(404) unless current_hr_app_instance
    end
  end
end
