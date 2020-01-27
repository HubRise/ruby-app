require "rails_helper"

RSpec.describe HubriseApp::HrAppInstance::Refresh do
  describe "#refresh_via_api_client" do
    let(:api_client) do
      double(
        app_instance_id: "x_app_instance_id",
        access_token: "x_access_token",
        catalog_id: "x_catalog_id",
        customer_list_id: "x_customer_list_id",
        account_id: nil,
        location_id: nil
      )
    end

    let(:hr_app_instance) do
      HubriseApp::HrAppInstance.create(
        hr_id: "x_app_instance_id",
        hr_account: nil,
        hr_location: nil,
        hr_access_token: "y_access_token",
        hr_catalog_id: "y_catalog_id",
        hr_customer_list_id: "y_customer_list_id"
      )
    end

    it "refreshes app instance" do
      HubriseApp::HrAppInstance::Refresh.run(hr_app_instance, api_client)
      expect(hr_app_instance.reload).to have_attributes(
        hr_id: "x_app_instance_id",
        hr_account: nil,
        hr_location: nil,
        hr_access_token: "x_access_token",
        hr_catalog_id: "x_catalog_id",
        hr_customer_list_id: "x_customer_list_id"
      )
    end

    it "assigns fresh account if connected" do
      hr_account = create(:hr_account, hr_id: "x_account_id")
      api_client = double(
        app_instance_id: "x_app_instance_id",
        access_token: "x_access_token",
        catalog_id: "x_catalog_id",
        customer_list_id: "x_customer_list_id",
        account_id: "x_account_id",
        location_id: nil
      )

      expect(HubriseApp::HrAccount).to receive(:refresh_or_create_via_api_client).with(api_client, "x_account_id").and_return(hr_account)
      HubriseApp::HrAppInstance::Refresh.run(hr_app_instance, api_client)
      expect(HubriseApp::HrAppInstance.last).to have_attributes(
        hr_id: "x_app_instance_id",
        hr_account: hr_account,
        hr_location: nil,
        hr_access_token: "x_access_token",
        hr_catalog_id: "x_catalog_id",
        hr_customer_list_id: "x_customer_list_id"
      )
    end

    it "assigns fresh location if connected" do
      hr_location = create(:hr_location, hr_id: "x_location_id")
      api_client = double(
        app_instance_id: "x_app_instance_id",
        access_token: "x_access_token",
        catalog_id: "x_catalog_id",
        customer_list_id: "x_customer_list_id",
        account_id: nil,
        location_id: "x_location_id"
      )

      expect(HubriseApp::HrLocation).to receive(:refresh_or_create_via_api_client).with(api_client, "x_location_id").and_return(hr_location)
      HubriseApp::HrAppInstance::Refresh.run(hr_app_instance, api_client)
      expect(HubriseApp::HrAppInstance.last).to have_attributes(
        hr_id: "x_app_instance_id",
        hr_account: nil,
        hr_location: hr_location,
        hr_access_token: "x_access_token",
        hr_catalog_id: "x_catalog_id",
        hr_customer_list_id: "x_customer_list_id"
      )
    end
  end
end
