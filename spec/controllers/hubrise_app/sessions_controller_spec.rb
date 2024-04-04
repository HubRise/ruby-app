# frozen_string_literal: true
require "rails_helper"

RSpec.describe(HubriseApp::SessionsController, type: :controller) do
  routes { HubriseApp::Engine.routes }

  let(:user) { create(:user) }

  describe "DELETE" do
    it "logs new user in" do
      session[:user_id] = user.id

      delete :destroy

      expect(session[:user_id]).to be_nil
    end
  end
end
