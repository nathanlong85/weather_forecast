# frozen_string_literal: true

# A custom error class for when a geocoding or forecast
# HTTP request fails
class HttpFetchError < StandardError; end
