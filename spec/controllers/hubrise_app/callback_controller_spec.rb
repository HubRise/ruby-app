require "rails_helper"

RSpec.describe HubriseApp::Override::CallbackController, type: :controller do
  routes { HubriseApp::Engine.routes }
  let!(:hr_app_instance) { create(:hr_app_instance, hr_id: "hr_id1") }

  describe "POST event" do
    it "delegates to HandleEvent service" do
      expect(HubriseApp::Services::HandleEvent).to receive(:run).with(hr_app_instance, a_hash_including(key: "val"))
      post :event, params: { key: "val", app_instance_id: "hr_id1" }
    end

    it "heads with 404 if app instance not found" do
      expect(HubriseApp::Services::HandleEvent).to_not receive(:run)
      post :event, params: { key: "val", app_instance_id: "hr_id2" }
      expect(response).to have_http_status(404)
    end
  end

  describe "GET disconnect" do
    it "delegates to DisconnectInstance service" do
      expect(HubriseApp::Services::DisconnectAppInstance).to receive(:run).with(hr_app_instance)
      get :disconnect, params: { app_instance_id: "hr_id1" }
    end

    it "heads with 404 if app instance not found" do
      expect(HubriseApp::Services::DisconnectAppInstance).to_not receive(:run)
      get :disconnect, params: { app_instance_id: "hr_id2" }
      expect(response).to have_http_status(404)
    end
  end
end
