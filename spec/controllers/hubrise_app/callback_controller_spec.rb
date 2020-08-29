require "rails_helper"

RSpec.describe HubriseApp::CallbackController, type: :controller do
  routes { HubriseApp::Engine.routes }
  let!(:app_instance) { create(:app_instance, hr_id: "hr_id1") }

  describe "POST event" do
    it "heads with 200" do
      post :event, params: { key: "val", app_instance_id: "hr_id1" }
      expect(response).to have_http_status(200)
    end

    it "heads with 404 if app instance not found" do
      post :event, params: { key: "val", app_instance_id: "hr_id2" }
      expect(response).to have_http_status(404)
    end
  end

  describe "GET disconnect" do
    it "heads with 200" do
      get :disconnect, params: { app_instance_id: "hr_id1" }
      expect(response).to have_http_status(200)
    end

    it "heads with 404 if app instance not found" do
      get :disconnect, params: { app_instance_id: "hr_id2" }
      expect(response).to have_http_status(404)
    end
  end
end
