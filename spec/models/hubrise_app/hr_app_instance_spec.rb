require "rails_helper"

RSpec.describe HubriseApp::HrAppInstance do
  describe ".refresh_or_create_via_api_client" do
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

    it "creates new app instance" do
      expect { described_class.refresh_or_create_via_api_client(api_client) }.to change(described_class, :count).by(1)
      expect(described_class.last).to have_attributes(
        hr_id: "x_app_instance_id",
        hr_account: nil,
        hr_location: nil,
        hr_access_token: "x_access_token",
        hr_catalog_id: "x_catalog_id",
        hr_customer_list_id: "x_customer_list_id"
      )
    end

    it "refreshes existing app instance" do
      existing_hr_app_instance = described_class.create(
        hr_id: "x_app_instance_id",
        hr_account: nil,
        hr_location: nil,
        hr_access_token: "y_access_token",
        hr_catalog_id: "y_catalog_id",
        hr_customer_list_id: "y_customer_list_id"
      )

      expect { described_class.refresh_or_create_via_api_client(api_client) }.to_not change(described_class, :count)
      expect(existing_hr_app_instance.reload).to have_attributes(
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
      described_class.refresh_or_create_via_api_client(api_client)
      expect(described_class.last).to have_attributes(
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
      described_class.refresh_or_create_via_api_client(api_client)
      expect(described_class.last).to have_attributes(
        hr_id: "x_app_instance_id",
        hr_account: nil,
        hr_location: hr_location,
        hr_access_token: "x_access_token",
        hr_catalog_id: "x_catalog_id",
        hr_customer_list_id: "x_customer_list_id"
      )
    end
  end

  describe "#api_client" do
    it "builds api client" do
      hr_app_instance = HubriseApp::HrAppInstance.new(hr_id: "x_app_instance_id",
                                                      hr_access_token: "x_access_token",
                                                      hr_account_id: "x_account_id",
                                                      hr_location_id: "x_account_id",
                                                      hr_catalog_id: "x_catalog_id",
                                                      hr_customer_list_id: "x_customer_list_id")
      api_client = hr_app_instance.api_client

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
