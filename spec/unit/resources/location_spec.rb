require 'spec_helper'

shared_examples 'location' do
  step_into :location
  recipe do
    api_token = node['snipeit']['api']['token']
    location 'Building 1' do
      address '16011 NE 36th Way'
      city 'Redmond'
      state 'WA'
      zip '98052'
      currency 'USD'
      token api_token
    end

    location 'Building 2' do
      address '16021 NE 36th St'
      city 'Redmond'
      state 'WA'
      zip '98052'
      currency 'USD'
      token api_token
    end
  end
end

describe 'lab_core::location' do
  url = 'http://fakeymcfakerton.corp.mycompany.com/api/v1/locations'
  include_examples 'location'
  context 'when the model exists' do
    it {
      is_expected.to_not post_http_request('create location[Building 1]')
        .with(url: url)
    }
  end

  context 'when the model does not exist' do
    message = {
      name: 'Building 2',
      address: '16021 NE 36th St',
      state: 'WA',
      country: 'US',
      zip: '98052',
      currency: 'USD',
    }
    it {
      is_expected.to post_http_request('create location[Building 2]')
        .with(url: url, message: message.to_json)
    }
  end
end
