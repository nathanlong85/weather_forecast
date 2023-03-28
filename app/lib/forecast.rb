class Forecast
  attr_reader :address, :city, :coords, :periods, :state, :zip_code

  def initialize(address:, city:, state:, zip_code:)
    self.address = address
    self.city = city
    self.state = state
    self.zip_code = zip_code
  end

  def fetch
    self.coords = GeocodeClient.fetch_coords(address:, city:, state:, zip_code:)
    raw_forecast = WeatherApiClient.fetch_forecast(**coords)

    self.periods = raw_forecast
  end

  private

  attr_writer :address, :city, :coords, :periods, :state, :zip_code

  def extract_periods(raw_forecast)
    #  Only take the necessary fields from the forecast data
    raw_forecast['periods'].map do |period|
      period.slice('number', 'name', 'temperature', 'detailedForecast',
        'startTime', 'endTime')
    end
  end
end
