class GeocodeClient
  COUNTRY = 'US'.freeze
  BASE_URL = 'http://dev.virtualearth.net/REST/v1/Locations'.freeze
  API_KEY = 'AiDmXQ7WvxqAPNZCjwO_v4vwrPN5KXl5VdnV96QaaiKT1BjF40VSKtom36a2uWzx'.freeze

  class << self
    def fetch_coords(state:, city:, address:, zip_code:)
      conn = Faraday.new(
        url: BASE_URL,
        params: generate_params(state:, city:, address:, zip_code:)
      )

      res = conn.get
      parsed = JSON.parse(res.body)
      lat, lon = parsed['resourceSets'][0]['resources'][0].dig('point', 'coordinates')

      { latitude: lat, longitude: lon }
    end

    private

    def generate_params(state:, city:, address:, zip_code:)
      { addressLine: address,
        adminDistrict: state,
        countryRegion: COUNTRY,
        key: API_KEY,
        locality: city,
        postalCode: zip_code }
    end
  end
end
