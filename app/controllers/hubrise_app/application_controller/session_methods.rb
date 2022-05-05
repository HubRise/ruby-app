module HubriseApp::ApplicationController::SessionMethods
  extend ActiveSupport::Concern
  included do
    protect_from_forgery with: :reset_session
    helper_method :current_user, :logged_in?
  end

  def login(user)
    session[:user_id] = user.id
    @current_user  = user
  end

  def logout
    session[:user_id] = nil
  end

  def current_user
    @current_user ||= User.where(id: session[:user_id]).take
  end

  def logged_in?
    !!current_user
  end

  def ensure_authenticated!
    unless logged_in?
      redirect_to(build_hubrise_oauth_login_url, allow_other_host: true)
      return
    end

    yield if block_given?
  end
end
