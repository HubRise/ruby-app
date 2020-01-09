module HubriseApp::ApplicationController::SessionMethods
  extend ActiveSupport::Concern
  included do
    protect_from_forgery with: :reset_session
    helper_method :current_hr_user, :logged_in?
  end

  def login(hr_user)
    session[:user_id] = hr_user.id
    @current_hr_user  = hr_user
  end

  def logout
    session[:user_id] = nil
  end

  def current_hr_user
    @current_hr_user ||= HubriseApp::HrUser.where(id: session[:user_id]).take
  end

  def logged_in?
    !!current_hr_user
  end

  def ensure_authenticated!
    redirect_to(build_hubrise_oauth_login_url) unless logged_in?
  end
end
