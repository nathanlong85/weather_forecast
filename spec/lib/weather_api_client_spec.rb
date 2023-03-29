# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherApiClient do
  describe '.fetch_forecast' do
    subject(:resulting_forecast) do
      described_class.fetch_forecast(latitude:, longitude:)
    end

    let(:latitude) { 33.061012 }
    let(:longitude) { -80.159211 }

    context 'when the request is successful' do
      # Including extra data that isn't needed to ensure it gets filtered
      # out before being returned
      let(:response_json) do
        Rails.root.join('spec/fixtures/weather_api_valid.json').read
      end

      let(:expected_return_data) do
        {
          current: {
            temp_f: 73.4,
            condition: {
              text: 'Partly cloudy',
              icon: '//cdn.weatherapi.com/weather/64x64/day/116.png',
              code: 1003
            }
          },
          forecast: {
            forecastday: [
              {
                date: '2023-03-28',
                day: {
                  maxtemp_f: 69.3,
                  mintemp_f: 63.5,
                  condition: {
                    text: 'Partly cloudy',
                    icon: '//cdn.weatherapi.com/weather/64x64/day/116.png',
                    code: 1003
                  }
                }
              }
            ]
          }
        }.deep_stringify_keys
      end

      before do
        stub_request(:get, %r{api\.weatherapi\.com/v1/forecast\.json})
          .to_return(status: 200, body: response_json)
      end

      it 'requests the correct url' do
        resulting_forecast

        expect(WebMock).to have_requested(
          :get, 'http://api.weatherapi.com/v1/forecast.json'
        ).with(
          query: {
            key: described_class::API_KEY,
            q: "#{latitude},#{longitude}",
            days: described_class::FORECAST_DAYS,
            aqi: 'no',
            alerts: 'no'
          }
        )
      end

      it 'returns the correct forecast data' do
        expect(resulting_forecast).to eq(expected_return_data)
      end
    end
  end
end
