require 'rails_helper'

RSpec.describe 'App instalation', type: :request do
  before do
    stub_hr_api_request(:get, "v1/accounts/x_account_id",
                        access_token: 'x_token',
                        response_body: { name: 'account1', currency: 'CUR1' })
    stub_hr_api_request(:get, "v1/locations/x_location_id",
                        access_token: 'x_token',
                        response_body: { name: 'location1', account: { name: 'account2', currency: 'CUR2' }})
  end

  it 'installs new account instance' do
    stub_hr_oauth_request('some_code', response_body: {
                                          access_token:     'x_token',
                                          app_instance_id:  'x_app_instance_id',
                                          account_id:       'x_account_id',
                                          catalog_id:       'x_catalog_id',
                                          customer_list_id: 'x_customer_list_id'
                                        })

    get '/hubrise/connect', code: 'some_code'

    app_instance = AppInstance.where(hr_id: 'x_app_instance_id').take

    aggregate_failures do
      expect(app_instance).to have_attributes(app_name: 'Dummy', access_token: 'x_token', hr_catalog_id: 'x_catalog_id', hr_customer_list_id: 'x_customer_list_id')
      expect(app_instance.account).to have_attributes(hr_id: 'x_account_id', name: 'account1', currency: 'CUR1')
      expect(app_instance.location).to be_nil
      expect(response).to redirect_to(open_url(app_instance_id: 'x_app_instance_id', subdomain: 'dummy'))
    end
  end

  it 'installs new location instance' do
    stub_hr_oauth_request('some_code', response_body: {
                                          access_token:     'x_token',
                                          app_instance_id:  'x_app_instance_id',
                                          account_id:       'x_account_id',
                                          location_id:      'x_location_id'
                                        })

    get '/hubrise/connect', code: 'some_code'

    app_instance = AppInstance.where(hr_id: 'x_app_instance_id').take

    aggregate_failures do
      expect(app_instance).to have_attributes(app_name: 'Dummy', access_token: 'x_token', hr_catalog_id: nil, hr_customer_list_id: nil)
      expect(app_instance.account).to   have_attributes(hr_id: 'x_account_id',  name: 'account2', currency: 'CUR2')
      expect(app_instance.location).to  have_attributes(hr_id: 'x_location_id', name: 'location1')
      expect(response).to redirect_to(open_url(app_instance_id: 'x_app_instance_id', subdomain: 'dummy'))
    end
  end
end
