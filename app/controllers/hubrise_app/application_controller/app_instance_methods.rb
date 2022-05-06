module HubriseApp::ApplicationController::AppInstanceMethods
  extend ActiveSupport::Concern
  included do
    helper_method :current_app_instance
  end

  def hr_app_instance_id
    params[:app_instance_id]
  end

  def current_app_instance
    if current_user
      @app_instance ||= HubriseApp::Services::ResolveAppInstance.run(current_user.app_instances, hr_app_instance_id, self)
    end
  end

  def ensure_app_instance_found!
    if hr_app_instance_id.blank?
      render(plain: "Something went wrong. Please try to reopen from Hubrise Dashboard.")
    elsif current_app_instance.nil?
      redirect_to(build_hubrise_oauth_authorize_url, allow_other_host: true)
    end
  end

  def default_url_options
    super.merge(app_instance_id: hr_app_instance_id || current_app_instance&.hr_id)
  end
end
