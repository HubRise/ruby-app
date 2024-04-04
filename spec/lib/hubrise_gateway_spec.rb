# frozen_string_literal: true
require "rails_helper"

RSpec.describe(HubriseApp::HubriseGateway) do
  let(:hubrise_gateway) { HubriseApp::HubriseGateway.new(HubriseApp::CONFIG) }

  describe "#build_api_client_from_app_instance" do
    it "builds api client" do
      hr_app_instance = AppInstance.new(hr_id: "x_app_instance_id",
                                        access_token: "x_access_token",
                                        hr_account_id: "x_account_id",
                                        hr_location_id: "x_account_id",
                                        hr_catalog_id: "x_catalog_id",
                                        hr_customer_list_id: "x_customer_list_id")
      api_client = hubrise_gateway.build_api_client_from_app_instance(hr_app_instance)

      expect(api_client).to be_an_instance_of(HubriseClient::V1)
      expect(api_client).to have_attributes(
        access_token: "x_access_token",
        app_instance_id: "x_app_instance_id",
        account_id: "x_account_id",
        location_id: "x_account_id",
        catalog_id: "x_catalog_id",
        customer_list_id: "x_customer_list_id"
      )
    end
  end
end
