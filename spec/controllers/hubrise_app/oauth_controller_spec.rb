# frozen_string_literal: true
require "rails_helper"

RSpec.describe(HubriseApp::OauthController, type: :controller) do
  routes { HubriseApp::Engine.routes }

  let(:user) { create(:user) }
  let(:app_instance) { create(:app_instance) }

  before do
    allow_any_instance_of(HubriseApp::HubriseGateway).to receive(:build_api_client_from_authorization_code)
      .with("some_code")
      .and_return(api_client)
  end

  describe "GET login_callback" do
    let(:api_client) { double(user_id: user.hr_id, app_instance_id: nil) }

    subject do
      expect(HubriseApp::Refresher::User).to receive(:run).with(user, api_client).and_return(user)
      get :login_callback, params: { code: "some_code" }
    end

    it "logs new user in" do
      subject
      expect(session[:user_id]).to eq(user.id)
    end

    it "redirects to open path" do
      expect(subject).to redirect_to("/hubrise_open")
    end
  end

  describe "GET connect_callback" do
    let(:api_client) { double(app_instance_id: app_instance.hr_id) }

    subject do
      expect(HubriseApp::Services::ConnectAppInstance).to receive(:run).with(api_client, controller).and_return(app_instance)
      get :connect_callback, params: { code: "some_code" }
    end

    it "assigns new instance to logged in user" do
      session[:user_id] = user.id
      subject
      expect(user.app_instances.all).to eq([app_instance])
    end

    it "redirects to oauth login if not logged in" do
      expect(subject).to redirect_to(
        "http://dummy.hubrise.host:4003/oauth2/v1/authorize?" \
          "redirect_uri=#{CGI.escape('http://test.host/hubrise_oauth/login_callback?app_instance_id=' + app_instance.hr_id)}&" \
          "scope=profile_with_email&" \
          "client_id=dummy_id"
      )
    end

    it "redirects to open path if logged in" do
      session[:user_id] = user.id
      expect(subject).to redirect_to("/hubrise_open?app_instance_id=#{app_instance.hr_id}")
    end
  end

  describe "GET authorize_callback" do
    let(:api_client) { double(app_instance_id: app_instance.hr_id) }

    subject do
      get :authorize_callback, params: { code: "some_code" }
    end

    it "redirects if not logged in" do
      subject
      expect(user.app_instances.all).to be_empty
      expect(response.status).to eq(302)
    end

    it "assigns app instance if logged in" do
      session[:user_id] = user.id
      subject
      expect(user.app_instances.all).to eq([app_instance])
    end

    context "with invalid app instance" do
      let(:api_client) { double(app_instance_id: "wrong_id") }

      it "renders error if app instance not found" do
        session[:user_id] = user.id
        subject
        expect(response.body).to include("Something went wrong")
      end
    end
  end
end
