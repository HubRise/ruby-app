module HubriseApp
  class CallbackController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :ensure_hr_app_instance_found!
  
    def event
      yield if block_given?
      head 200
    end

    def disconnect
      yield if block_given?
      head 200
    end

    protected

    def current_hr_app_instance
      @hr_app_instance ||= HubriseApp::HrAppInstance.where(hr_id: params[:app_instance_id]).take
    end

    def ensure_hr_app_instance_found!
      head(404) unless current_hr_app_instance
    end
  end
end