# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast do
  let(:address) { '1234 Some Street' }
  let(:city) { 'Some City' }
  let(:state) { ForecastForm::VALID_STATES.first }
  let(:zip_code) { '12345-6789' }

  let(:forecast) { described_class.new(address:, city:, state:, zip_code:) }

  describe '.new' do
    it 'assigns the attribute values' do
      expect(forecast).to have_attributes(
        address:, city:, state:, zip_code:
      )
    end
  end

  describe '.fetch' do
    let(:latitude) { 33.061012 }
    let(:longitude) { -80.159211 }

    let(:forecast_data) { 'Some forecast data' }

    context 'when the forecast is already cached for the zip code' do
      before { Rails.cache.write(zip_code, 'Some Data') }

      it 'sets the `cached` attribute' do
        expect { forecast.fetch }.to change(forecast, :cached)
          .from(nil).to(true)
      end
    end

    context 'when the forecast is not yet cached for the zip code' do
      before do
        allow(BingMapsClient).to receive(:fetch_coords)
          .with(address:, city:, state:, zip_code:)
          .and_return(latitude:, longitude:)

        allow(WeatherApiClient).to receive(:fetch_forecast)
          .with(latitude:, longitude:)
          .and_return(forecast_data)
      end

      it 'sets the `cached` attribute' do
        expect { forecast.fetch }.to change(forecast, :cached)
          .from(nil).to(false)
      end

      it 'sets the `data` attribute' do
        expect { forecast.fetch }.to change(forecast, :data)
          .from(nil).to(forecast_data)
      end

      it 'caches the data' do
        expect { forecast.fetch }.to change { Rails.cache.read(zip_code) }
          .from(nil).to(forecast_data)
      end
    end
  end
end
