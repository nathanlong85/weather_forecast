# frozen_string_literal: true

require 'rails_helper'
require_relative '../shared_context'

# This only tests for a successful form submission. Form errors
# are covered in the 'forecasts#index' feature specs.
RSpec.describe 'weather forecast' do
  include_context 'with the index form filled out'
  include_context 'with successful external API responses stubbed'

  before { click_button('Submit') }

  it 'displays the address at the top of the page' do
    expect(page).to have_content("#{address}, #{city}, #{state} #{zip_code}")
  end

  # rubocop:disable RSpec/MultipleExpectations
  it 'displays the current forecast correctly' do
    within('#current-conditions-card') do
      expect(page).to have_content('73.4 °F')
      expect(page).to have_content('Partly cloudy')
    end
  end

  it 'displays the extended forecast correctly' do
    within('#extended-forecast-cards') do
      expect(page).to have_content('2023-03-28')
      expect(page).to have_content('63.5 / 69.3')
      expect(page).to have_content('Partly cloudy')
    end
  end
  # rubocop:enable RSpec/MultipleExpectations
end
