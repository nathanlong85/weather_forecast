# frozen_string_literal: true

require 'rails_helper'
require_relative '../shared_context'

RSpec.describe 'forecast lookup form' do
  include_context 'with the index form filled out'

  context 'when all fields are filled out correctly' do
    context 'when an error occurs while fetching forecast data' do
      let(:err_msg) { 'Unable to fetch geocoding data: Status 503' }

      before do
        # Intentionally cause the geocoding request to fail to test
        # the error handling and flash behavior
        stub_request(:get, %r{dev\.virtualearth\.net/REST/v1})
          .to_return(status: 503)

        click_button('Submit')
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 're-renders the index page to display errors' do
        expect(page).to have_selector('#forecast-lookup-form')
        expect(page).to have_current_path(forecast_path, ignore_query: true)
      end
      # rubocop:enable RSpec/MultipleExpectations

      it 'displays the error in the flash container' do
        within('#flash-container') do
          expect(page).to have_content(err_msg)
        end
      end
    end

    context 'when no errors occur while fetching forecast data' do
      include_context 'with successful external API responses stubbed'

      # rubocop:disable RSpec/MultipleExpectations
      it 'does not re-render the index page to display errors' do
        click_button('Submit')
        expect(page).not_to have_selector('#forecast-lookup-form')
        expect(page).to have_current_path(forecast_path, ignore_query: true)
      end
      # rubocop:enable RSpec/MultipleExpectations
    end
  end

  context 'when not all fields are properly filled out' do
    shared_examples_for 'an error being displayed on the form' do
      before { click_button('Submit') }

      it 'displays the correct error on the form' do
        within('#forecast-lookup-form') do
          expect(page).to have_content(err_msg)
        end
      end
    end

    # The form field error message behavior has already been tested in the
    # ForecastForm model specs, so if one `state` error displays,
    # the others will as well
    context 'when the state field is missing' do
      let(:state) { '' }
      let(:err_msg) { "State can't be blank" }

      it_behaves_like 'an error being displayed on the form'
    end

    context 'when the city field is missing' do
      let(:city) { '' }
      let(:err_msg) { "City can't be blank" }

      it_behaves_like 'an error being displayed on the form'
    end

    context 'when the address field is missing' do
      let(:address) { '' }
      let(:err_msg) { "Address can't be blank" }

      it_behaves_like 'an error being displayed on the form'
    end

    # The form field error message behavior has already been tested in the
    # ForecastForm model specs, so if one `zip_code` error displays,
    # the others will as well
    context 'when the zip code field is missing' do
      let(:zip_code) { '' }
      let(:err_msg) { "Zip code can't be blank" }

      it_behaves_like 'an error being displayed on the form'
    end
  end
end
