require "rails_helper"

RSpec.describe HubriseApp::Refresher::AppInstance do
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

    let(:app_instance) do
      AppInstance.create(
        hr_id: "x_app_instance_id",
        account: nil,
        location: nil,
        access_token: "y_access_token",
        hr_catalog_id: "y_catalog_id",
        hr_customer_list_id: "y_customer_list_id"
      )
    end

    it "refreshes app instance" do
      HubriseApp::Refresher::AppInstance.run(app_instance, api_client)
      expect(app_instance.reload).to have_attributes(
        hr_id: "x_app_instance_id",
        account: nil,
        location: nil,
        access_token: "x_access_token",
        hr_catalog_id: "x_catalog_id",
        hr_customer_list_id: "x_customer_list_id"
      )
    end

    it "assigns fresh account if connected" do
      account = create(:account, hr_id: "x_account_id")
      api_client = double(
        app_instance_id: "x_app_instance_id",
        access_token: "x_access_token",
        catalog_id: "x_catalog_id",
        customer_list_id: "x_customer_list_id",
        account_id: "x_account_id",
        location_id: nil
      )

      expect(HubriseApp::Refresher::Account).to receive(:run).with(account, api_client)
      HubriseApp::Refresher::AppInstance.run(app_instance, api_client)
      expect(AppInstance.last).to have_attributes(
        hr_id: "x_app_instance_id",
        account: account,
        location: nil,
        access_token: "x_access_token",
        hr_catalog_id: "x_catalog_id",
        hr_customer_list_id: "x_customer_list_id"
      )
    end

    it "assigns fresh location if connected" do
      location = create(:location, hr_id: "x_location_id")
      api_client = double(
        app_instance_id: "x_app_instance_id",
        access_token: "x_access_token",
        catalog_id: "x_catalog_id",
        customer_list_id: "x_customer_list_id",
        account_id: nil,
        location_id: "x_location_id"
      )

      expect(HubriseApp::Refresher::Location).to receive(:run).with(location, api_client)
      HubriseApp::Refresher::AppInstance.run(app_instance, api_client)
      expect(AppInstance.last).to have_attributes(
        hr_id: "x_app_instance_id",
        account: nil,
        location: location,
        access_token: "x_access_token",
        hr_catalog_id: "x_catalog_id",
        hr_customer_list_id: "x_customer_list_id"
      )
    end
  end
end
