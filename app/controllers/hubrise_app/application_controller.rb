module HubriseApp
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :reset_session
    helper_method :current_hr_user, :current_hr_app_instance
  
    protected

      ###########
      # SESSION #
      ###########

      def login(hr_user)
        session[:user_id] = hr_user.id
        @current_hr_user  = hr_user
      end
    
      def logout
        session[:user_id] = nil
      end
    
      def current_hr_user
        @current_hr_user ||= HrUser.where(id: session[:user_id]).take
      end
    
      def logged_in?
        !!current_hr_user
      end
      
      def ensure_authenticated!
        redirect_to(hubrise_oauth_login_url) unless logged_in?
      end

      ##############
      # HR METHODS #
      ##############

      def hr_app_instance_id
        params[:app_instance_id]
      end

      def default_url_options
        super.merge(app_instance_id: hr_app_instance_id || current_hr_app_instance.hr_id)
      end

      def current_hr_app_instance
        @hr_app_instance ||= current_hr_user.hr_app_instances.where(hr_id: hr_app_instance_id).includes(:hr_account, :hr_location).take
      end
    
      def hubrise_oauth_login_url
        HubriseGateway.build_login_authorization_url(
          hubrise_oauth_login_callback_url
        )
      end

      def hubrise_oauth_authorize_url
        HubriseGateway.build_app_authorization_url(hr_app_instance_id,
          hubrise_oauth_authorize_callback_url
        )
      end

      def ensure_hr_app_instance_found!
        if hr_app_instance_id.blank?
          render(plain: 'Something went wrong. Please try to reopen from Hubrise Dashboard.')
        elsif current_hr_app_instance.nil?
          redirect_to(hubrise_oauth_authorize_url)
        end
      end
    end
end
