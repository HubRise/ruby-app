module HubriseApp::ApplicationController::AppInstanceMethods
  extend ActiveSupport::Concern
  included do
    helper_method :current_hr_app_instance
  end

  def hr_app_instance_id
    params[:app_instance_id]
  end

  def current_hr_app_instance
    @hr_app_instance ||= current_hr_user && begin
      current_hr_user.hr_app_instances.merge(hr_app_instances_scope).
                                       where(hr_id: hr_app_instance_id).
                                       includes(:hr_account, :hr_location).
                                       take
    end
  end

  def ensure_hr_app_instance_found!
    if hr_app_instance_id.blank?
      render(plain: "Something went wrong. Please try to reopen from Hubrise Dashboard.")
    elsif current_hr_app_instance.nil?
      redirect_to(build_hubrise_oauth_authorize_url)
    end
  end

  def default_url_options
    super.merge(app_instance_id: hr_app_instance_id || current_hr_app_instance&.hr_id)
  end

  def hr_app_instances_scope
    HubriseApp::HrAppInstance
  end
end
