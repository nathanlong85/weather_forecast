# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BingMapsClient do
  describe '.fetch_coords' do
    subject(:resulting_coords) do
      described_class.fetch_coords(state:, city:, address:, zip_code:)
    end

    let(:state) { ForecastForm::VALID_STATES.first }
    let(:city) { 'Some City' }
    let(:address) { '1234 Some Street' }
    let(:zip_code) { '12345' }

    context 'when the request is successful' do
      let(:latitude) { 33.061012 }
      let(:longitude) { -80.159211 }

      # Only including JSON fields we care about to simplify the tests
      # and avoid storing unnecessary data
      let(:response_json) do
        {
          resourceSets: [
            {
              resources: [
                {
                  point: {
                    coordinates: [latitude, longitude]
                  }
                }
              ]
            }
          ]
        }.to_json
      end

      before do
        stub_request(:get, %r{dev\.virtualearth\.net/REST/v1})
          .to_return(status: 200, body: response_json)
      end

      it 'requests the correct url' do
        resulting_coords

        expect(WebMock).to have_requested(
          :get, 'http://dev.virtualearth.net/REST/v1/Locations'
        ).with(
          query: {
            key: described_class::API_KEY,
            addressLine: address,
            adminDistrict: state,
            countryRegion: BingMapsClient::COUNTRY,
            locality: city,
            postalCode: zip_code
          }
        )
      end

      it 'returns the latitude and longitude' do
        expect(resulting_coords).to eq(latitude:, longitude:)
      end
    end
  end
end
