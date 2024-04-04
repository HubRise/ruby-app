# frozen_string_literal: true
require "rails_helper"

RSpec.describe(HubriseApp::CallbackController, type: :controller) do
  routes { HubriseApp::Engine.routes }
  let!(:app_instance) { create(:app_instance, hr_id: "hr_id1") }

  describe "POST event" do
    describe "with valid hmac" do
      it "heads with 200" do
        request.headers["X-Hubrise-Hmac-Sha256"] = "edb1136a4bd15e6637f2720b9804f21a4913ce41e5ba31b8ad62bad00fa53ce5"
        post :event, params: { key: "val", app_instance_id: "hr_id1" }, as: :json

        expect(response).to have_http_status(200)
      end
    end

    it "heads with 401 for invalid hmac" do
      request.headers["X-Hubrise-Hmac-Sha256"] = "wrong"
      post :event, params: { key: "val", app_instance_id: "hr_id1" }, as: :json

      expect(response).to have_http_status(401)
    end

    it "heads with 404 if app instance not found" do
      post :event, params: { key: "val", app_instance_id: "hr_id2" }, as: :json
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
