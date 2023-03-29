# frozen_string_literal: true

# Represents a weather forecast and holds all of the necessary attributes
class Forecast
  attr_reader :address, :cached, :city, :data, :state, :zip_code

  def initialize(address:, city:, state:, zip_code:)
    self.address = address
    self.city = city
    self.state = state
    self.zip_code = zip_code
  end

  def fetch
    self.cached = true

    # Caching forecast data by zip code per the requirements. Using a memory cache
    # to avoid a more complicated setup
    self.data = Rails.cache.fetch(zip_code, expires_in: 30.minutes) do
      self.cached = false
      self.coords = BingMapsClient.fetch_coords(address:, city:, state:, zip_code:)

      WeatherApiClient.fetch_forecast(**coords)
    end
  end

  private

  attr_accessor :coords
  attr_writer :address, :cached, :city, :data, :state, :zip_code
end
