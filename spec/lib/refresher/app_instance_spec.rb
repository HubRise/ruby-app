require "rails_helper"

RSpec.describe HubriseApp::Refresher::AppInstance do
  let!(:today) { Date.new(2020).tap(&method(:travel_to)) }

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

        expect(api_client).to receive(:get_catalog).with("catalog_idX").and_return(
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
            refreshed_at: today
          )
          expect(subject.location).to have_attributes(
            hr_id: "location_idX",
            api_data: a_hash_including("name" => "Some Location"),
            refreshed_at: today
          )
          expect(subject.catalog).to have_attributes(
            hr_id: "catalog_idX",
            api_data: a_hash_including("name" => "Some Catalog"),
            refreshed_at: today
          )
          expect(subject.customer_list).to have_attributes(
            hr_id: "customer_list_idX",
            api_data: a_hash_including("name" => "Some Customer List"),
            refreshed_at: today
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
              refreshed_at: today
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

    describe "existing app isntance" do
      let(:recently) { today - 1.minute }
      let(:app_instance) do
        create(:app_instance,
          hr_account_id: "account_idX",
          hr_location_id: "location_idX",
          hr_catalog_id: "catalog_idX",
          hr_customer_list_id: "customer_list_idX",
          refreshed_at: recently
        )
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
end
