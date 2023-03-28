class WeatherApiClient
  API_KEY = 'b97117b06e75492299523253232803'.freeze
  BASE_URL = 'http://api.weatherapi.com/v1'.freeze
  FORECAST_DAYS = 5

  class << self
    # Fetch and parse the weather forecast data
    def fetch_forecast(latitude:, longitude:)
      res = connection.get('forecast.json',
        q: "#{latitude},#{longitude}",
        days: FORECAST_DAYS,
        aqi: 'no',
        alerts: 'no')

      reduce_raw_forecast(res.body)
    end

    private

    def connection
      Faraday.new(
        url: BASE_URL,
        params: { key: API_KEY }
      )
    end

    # The forecast API returns a lot of data that doesn't need to be cached
    # and passed around. This method reduces it to what's important
    def reduce_raw_forecast(raw_data)
      JSON.parse(raw_data).tap do |d|
        d.slice!('current', 'forecast')
        d['current'].slice!('temp_f', 'condition')

        d['forecast']['forecastday'].map! do |forecastday|
          forecastday['day'].slice!('maxtemp_f', 'mintemp_f', 'condition')
          forecastday.slice('date', 'day')
        end
      end
    end
  end
end
