require "rails_helper"

RSpec.describe HubriseApp::ApplicationController, type: :controller do
  let(:hr_user) { create(:hr_user) }

  describe ".ensure_authenticated!" do
    subject { get :index }

    controller do
      include StubHostControllerUrlHelpers::HostAppUrlHelpers
      before_action :ensure_authenticated!

      def index
        render plain: :ok
      end
    end

    it "redirects to oauth login url if not logged in" do
      expect(subject).to redirect_to("http://dummy.hubrise.host:4003/oauth2/v1/authorize?redirect_uri=http%3A%2F%2Fhubrise_oauth_login_callback_url&scope=profile_with_email&client_id=dummy_id")
    end

    it "does not prevent an action if logged in" do
      session[:user_id] = hr_user.id
      subject
      expect(response.body).to eq("ok")
    end
  end

  describe ".ensure_hr_app_instance_found!" do
    controller do
      include StubHostControllerUrlHelpers::HostAppUrlHelpers
      before_action :ensure_hr_app_instance_found!

      def index
        render plain: :ok
      end
    end

    before { session[:user_id] = hr_user.id }

    it "renders error if app_instance_id not provided" do
      get :index
      expect(response.body).to include("Something went wrong")
    end

    it "tries to reauthorize if app instance not found" do
      get :index, params: { app_instance_id: "wrong" }
      expect(subject).to redirect_to("http://dummy.hubrise.host:4003/oauth2/v1/authorize?app_instance_id=wrong&redirect_uri=http%3A%2F%2Fhubrise_oauth_authorize_callback_url&scope&client_id=dummy_id")
    end

    it "does not prevent an action if app_instance found" do
      hr_user.assign_hr_app_instance(create(:hr_app_instance, hr_id: "x_app_instance_id"))
      get :index, params: { app_instance_id: "x_app_instance_id"}
      expect(response.body).to eq("ok")
    end
  end
end
