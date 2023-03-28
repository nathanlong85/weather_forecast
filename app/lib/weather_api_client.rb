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

      parse_and_reduce(res.body)
    end

    private

    def connection
      Faraday.new(
        url: BASE_URL,
        params: { key: API_KEY }
      )
    end

    # This API returns a lot of data that doesn't need to be cached and
    # passed around. This method reduces it
    def parse_and_reduce(res_body)
      JSON.parse(res_body).tap do |data|
        data.slice!('current', 'forecast')
        data['current'].slice!('temp_f', 'condition')

        data['forecast']['forecastday'].map! do |forecastday|
          forecastday['day'].slice!('maxtemp_f', 'mintemp_f', 'condition')
          forecastday.slice('date', 'day')
        end
      end
    end
  end
end
