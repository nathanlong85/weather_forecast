class NwsClient
  BASE_URL = 'https://api.weather.gov'

  class << self
    def fetch_forecast(latitude:, longitude:)
      conn = Faraday.new(url: BASE_URL)

      res = conn.get("/points/#{latitude.truncate(4)},#{longitude.truncate(4)}")
      JSON.parse(res.body)
    end
  end
end
