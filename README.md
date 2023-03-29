# Weather Forecast

## General Information
Displays a weather forecast using the supplied address on the index page. Provides:

- Current conditions
- Extended forecast
- Forecast data caching based on zip code with an indicator to show if there was a cache hit

## Application Specifics

- Ruby Version: 3.2.0
- Rails Version: 7.0.4.3
- Test Coverage: 100%
- Geocoding API: [Bing Maps Locations API](https://learn.microsoft.com/en-us/bingmaps/rest-services/locations)
- Weather Data API: [WeatherAPI](https://www.weatherapi.com)

### Running the Application

This application must be run from a host with internet access to retrieve weather data.

1. Clone the Github repo
2. Ensure the specified Ruby version is installed
3. Install bundler with `gem install bundler`
4. Run a `bundle install`
5. Run `bundle exec rails s` to start a Puma server on port 3000.
6. Navigate to `http://localhost:3000`

### Running the Test Suite

Assuming the steps from [Running the Application](#running-the-application) were followed, a simple `bundle exec rspec` from the project root should successfully run the test suite.

## Notes to the Reviewers

In order to showcase my Rails skills, I opted for doing all of the form validations on the server-side instead of going the JavaScript route. Also, I realize that API keys typically don't just go in the code to be seen by anybody. But it seemed ok in this situation as they aren't important and there's no secrets system in place to use.

Additionally, I'm sure it would make sense to take a closer look at the Geocoding results and offer the user more options to select the correct location if more than one is returned. That would make a great feature request for later.
