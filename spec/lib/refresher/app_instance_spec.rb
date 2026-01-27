# frozen_string_literal: true
require "rails_helper"

RSpec.describe(HubriseApp::Refresher::AppInstance) do
  let!(:now) { Date.new(2020).tap(&method(:travel_to)) }

  describe ".run" do
    let(:api_client) do
      double(
        access_token: "access_tokenX",
        account_id: "account_idX",
        location_id: "location_idX",
        catalog_id: "catalog_idX",
        customer_list_id: "customer_list_idX",
      )
    end

    subject do
      HubriseApp::Refresher::AppInstance.run(app_instance, api_client)
    end

    describe "new app instance" do
      let(:app_instance) { AppInstance.new(hr_id: "hr_idX") }

      it "refreshes app instance and its resources" do
        expect(api_client).to receive(:get_location).with("location_idX").and_return(
          double(data: ApiFixtures.location_json)
        ).twice

        expect(api_client).to receive(:get_catalog).with("catalog_idX", hide_data: true).and_return(
          double(data: ApiFixtures.catalog_json)
        )

        expect(api_client).to receive(:get_customer_list).with("customer_list_idX").and_return(
          double(data: ApiFixtures.customer_list_json)
        )

        subject

        aggregate_failures do
          expect(subject.account).to have_attributes(
            hr_id: "account_idX",
            api_data: a_hash_including("name" => "Some Account"),
            refreshed_at: now
          )
          expect(subject.location).to have_attributes(
            hr_id: "location_idX",
            api_data: a_hash_including("name" => "Some Location"),
            refreshed_at: now
          )
          expect(subject.catalog).to have_attributes(
            hr_id: "catalog_idX",
            api_data: a_hash_including("name" => "Some Catalog"),
            refreshed_at: now
          )
          expect(subject.customer_list).to have_attributes(
            hr_id: "customer_list_idX",
            api_data: a_hash_including("name" => "Some Customer List"),
            refreshed_at: now
          )
        end
      end

      describe "account level app instance" do
        let(:api_client) do
          double(
            access_token: "access_tokenX",
            account_id: "account_idX",
            location_id: nil,
            catalog_id: nil,
            customer_list_id: nil,
          )
        end

        it "refreshes app instance and its resources" do
          expect(api_client).to receive(:get_account).with("account_idX").and_return(
            double(data: ApiFixtures.account_json)
          )

          subject

          aggregate_failures do
            expect(subject.account).to have_attributes(
              hr_id: "account_idX",
              api_data: a_hash_including("name" => "Some Account"),
              refreshed_at: now
            )
            expect(subject).to have_attributes(
              location: nil,
              catalog: nil,
              customer_list: nil
            )
          end
        end
      end
    end

    describe "existing app instance" do
      let(:recently) { now - 1.minute }
      let(:app_instance) do
        create(:app_instance,
               hr_account_id: "account_idX",
               hr_location_id: "location_idX",
               hr_catalog_id: "catalog_idX",
               hr_customer_list_id: "customer_list_idX",
               refreshed_at: recently)
      end

      it "ignores recently refreshed app resources" do
        subject

        aggregate_failures do
          expect(subject.account).to have_attributes(hr_id: "account_idX", refreshed_at: recently)
          expect(subject.location).to have_attributes(hr_id: "location_idX", refreshed_at: recently)
          expect(subject.catalog).to have_attributes(hr_id: "catalog_idX", refreshed_at: recently)
          expect(subject.customer_list).to have_attributes(hr_id: "customer_list_idX", refreshed_at: recently)
        end
      end
    end
  end

  describe ".from_event" do
    let(:yesterday) { now - 1.day }
    let(:app_instance) do
      create(:app_instance,
             hr_account_id: "account_idX",
             hr_location_id: "location_idX",
             hr_catalog_id: "catalog_idX",
             hr_customer_list_id: "customer_list_idX",
             refreshed_at: yesterday)
    end
    let(:api_client) { HubriseApp::HubriseGateway.new.build_api_client_from_app_instance(app_instance) }

    subject { HubriseApp::Refresher::AppInstance.from_event(app_instance, event_params, api_client) }

    describe "with account event" do
      let(:event_params) do
        {
          "resource_type" => "account",
          "new_state" => ApiFixtures.account_json.merge("name" => "Updated Account"),
        }
      end

      it "updates the account" do
        subject
        expect(app_instance.account.api_data).to include("name" => "Updated Account")
        expect(app_instance.account.api_data).not_to(have_key("id"))
        expect(app_instance.account.refreshed_at).to eq(now)
      end
    end

    describe "with location event" do
      let(:event_params) do
        {
          "resource_type" => "location",
          "new_state" => ApiFixtures.location_json.deep_merge(
            "name" => "Updated Location",
            "account" => { "name" => "Updated Account" },
          ),
        }
      end

      it "updates the location and account" do
        subject

        aggregate_failures do
          expect(app_instance.location.api_data).to include("name" => "Updated Location")
          expect(app_instance.location.api_data).not_to(have_key("id"))
          expect(app_instance.location.api_data).not_to(have_key("account"))
          expect(app_instance.location.refreshed_at).to eq(now)

          expect(app_instance.account.api_data).to include("name" => "Updated Account")
          expect(app_instance.account.api_data).not_to(have_key("id"))
          expect(app_instance.account.refreshed_at).to eq(now)
        end
      end
    end

    describe "with catalog event" do
      let(:event_params) do
        {
          "resource_type" => "catalog",
          "id" => "catalog_idX",
        }
      end

      it "fetches api_data from the client and updates the catalog" do
        stub_hr_api_request(
          :get,
          "v1/catalogs/catalog_idX?hide_data=true",
          response_body: ApiFixtures.catalog_json.except("data").merge("name" => "Updated Catalog"),
          access_token: app_instance.access_token
        )
        subject
        expect(app_instance.catalog.api_data).to include("name" => "Updated Catalog")
        expect(app_instance.catalog.api_data).not_to(have_key("id"))
        expect(app_instance.catalog.refreshed_at).to eq(now)
      end
    end

    describe "with customer_list event" do
      let(:event_params) do
        {
          "resource_type" => "customer_list",
          "new_state" => ApiFixtures.customer_list_json.merge("name" => "Updated Customer List"),
        }
      end

      it "updates the customer_list" do
        subject
        expect(app_instance.customer_list.api_data).to include("name" => "Updated Customer List")
        expect(app_instance.customer_list.api_data).not_to(have_key("id"))
        expect(app_instance.customer_list.refreshed_at).to eq(now)
      end
    end
  end

  describe ".default_callback_events" do
    subject { HubriseApp::Refresher::AppInstance.default_callback_events(app_instance) }

    describe "with location, catalog, and customer_list" do
      let(:app_instance) do
        create(:app_instance,
               hr_account_id: "account_idX",
               hr_location_id: "location_idX",
               hr_catalog_id: "catalog_idX",
               hr_customer_list_id: "customer_list_idX")
      end

      it "returns events for all resources" do
        expect(subject).to eq({
          location: [:update],
          catalog: [:update],
          customer_list: [:update],
        })
      end
    end

    describe "with location only" do
      let(:app_instance) do
        create(:app_instance,
               hr_account_id: "account_idX",
               hr_location_id: "location_idX",
               hr_catalog_id: nil,
               hr_customer_list_id: nil)
      end

      it "returns events for location only" do
        expect(subject).to eq({
          location: [:update],
        })
      end
    end
  end
end
