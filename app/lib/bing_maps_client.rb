# Handles HTTP requests to the Bing Maps API
class BingMapsClient
  COUNTRY = 'US'.freeze
  BASE_URL = 'http://dev.virtualearth.net/REST/v1'.freeze
  API_KEY = 'AiDmXQ7WvxqAPNZCjwO_v4vwrPN5KXl5VdnV96QaaiKT1BjF40VSKtom36a2uWzx'.freeze

  class << self
    # Fetch latitude/longitude coordinates for an address using Bing's
    # Geocoding API
    def fetch_coords(state:, city:, address:, zip_code:)
      res = connection.get('Locations',
        addressLine: address,
        adminDistrict: state,
        countryRegion: COUNTRY,
        locality: city,
        postalCode: zip_code)

      parsed = JSON.parse(res.body)

      # For simplicity's sake, use the first location returned by the query
      lat, lon = parsed['resourceSets'][0]['resources'][0].dig('point', 'coordinates')

      { latitude: lat, longitude: lon }
    end

    private

    def connection
      Faraday.new(
        url: BASE_URL,
        params: { key: API_KEY }
      )
    end
  end
end
