require "rails_helper"

RSpec.describe HubriseApp::Override::OauthController, type: :controller do
  routes { HubriseApp::Engine.routes }

  let(:hr_user) { create(:hr_user) }
  let!(:api_client) do
    double(app_instance_id: "x_app_instance_id").tap do |api_client|
      allow_any_instance_of(HubriseApp::HubriseGateway).to receive(:build_api_client_from_authorization_code).with("some_code").and_return(api_client)
    end
  end

  describe "GET login_callback" do
    subject do
      expect(HubriseApp::HrUser).to receive(:refresh_or_create_via_api_client).with(api_client).and_return(hr_user)
      get :login_callback, params: { code: "some_code" }
    end

    it "logs new user in" do
      subject
      expect(session[:user_id]).to eq(hr_user.id)
    end

    it "redirects to open path" do
      expect(subject).to redirect_to("/hubrise_open")
    end
  end

  describe "GET connect_callback" do
    let(:hr_app_instance) { create(:hr_app_instance) }

    subject do
      expect(HubriseApp::HrAppInstance).to receive(:refresh_or_create_via_api_client).with(api_client).and_return(hr_app_instance)
      expect(HubriseApp::Services::ConnectAppInstance).to receive(:run).with(hr_app_instance, hubrise_callback_event_url: "http://test.host/hubrise_callback/event?app_instance_id=" + hr_app_instance.hr_id)
      get :connect_callback, params: { code: "some_code" }
    end

    it "assigns new instance to logged in user" do
      session[:user_id] = hr_user.id
      subject
      expect(hr_user.hr_app_instances.all).to eq([hr_app_instance])
    end

    it "redirects to oauth login if not logged in" do
      expect(subject).to redirect_to(
        "http://dummy.hubrise.host:4003/oauth2/v1/authorize?" \
          "redirect_uri=#{CGI.escape('http://test.host/hubrise_oauth/login_callback?app_instance_id=' + hr_app_instance.hr_id)}&" \
          "scope=profile_with_email&" \
          "client_id=dummy_id"
      )
    end

    it "redirects to open path if logged in" do
      session[:user_id] = hr_user.id
      expect(subject).to redirect_to("/hubrise_open?app_instance_id=#{hr_app_instance.hr_id}")
    end
  end

  describe ".authorize_callback" do
    subject do
      get :authorize_callback, params: { code: "some_code" }
    end

    it "calls #ensure_authenticated!" do
      expect(controller).to receive(:ensure_authenticated!)
      subject
    end

    it "assigns app instance if exists" do
      session[:user_id] = hr_user.id
      hr_app_instance = create(:hr_app_instance, hr_id: "x_app_instance_id")
      subject
      expect(hr_user.hr_app_instances.all).to eq([hr_app_instance])
    end

    it "renders error if app instance not found" do
      session[:user_id] = hr_user.id
      create(:hr_app_instance, hr_id: "wrong_id")
      subject
      expect(response.body).to include("Something went wrong")
    end
  end
end
