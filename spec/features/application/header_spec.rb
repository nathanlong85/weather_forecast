# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'header' do
  before { visit '/' }

  context 'when the user clicks the Weather Forecast link' do
    it 'takes the user to the index page' do
      within('#nav-header') { click_link('Weather Forecast') }
      expect(page).to have_current_path(root_path)
    end
  end

  context 'when the user clicks the Home link' do
    it 'takes the user to the index page' do
      within('#nav-header') { click_link('Home') }
      expect(page).to have_current_path(root_path)
    end
  end
end
