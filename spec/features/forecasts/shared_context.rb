require 'rails_helper'

RSpec.shared_context 'with the index form filled out' do
  let(:state) { ForecastForm::VALID_STATES.first }
  let(:city) { 'Some City' }
  let(:address) { '1234 Some Street' }
  let(:zip_code) { '12345' }

  before do
    visit '/'

    within('#forecast-lookup-form') do
      select(state, from: 'State')
      fill_in('City', with: city)
      fill_in('Address', with: address)
      fill_in('Zip Code', with: zip_code)
    end
  end
end

RSpec.shared_context 'with the external API responses stubbed' do
  let(:forecast_response) do
    JSON.parse(Rails.root.join('spec/fixtures/weather_api_valid.json').read)
  end

  before do
    # Using random coordinates here. It doesn't really matter.
    # Using .with to ensure the correct query params were passed
    allow(BingMapsClient).to receive(:fetch_coords)
      .with(state:, city:, address:, zip_code:)
      .and_return(latitude: 10, longitude: 10)

    allow(WeatherApiClient).to receive(:fetch_forecast)
      .with(latitude: 10, longitude: 10)
      .and_return(forecast_response)
  end
end
