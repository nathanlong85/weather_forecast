# frozen_string_literal: true

require 'rails_helper'
require_relative '../shared_context'

RSpec.describe 'cached indicator' do
  include_context 'with the index form filled out'
  include_context 'with the external API responses stubbed'

  before do
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(Forecast).to receive(:cached)
      .and_return(cached_value)
    # rubocop:enable RSpec/AnyInstance

    click_button('Submit')
  end

  context 'when the content has not been cached' do
    let(:cached_value) { false }

    it 'displays cached true' do
      expect(page).to have_content('Cached: false')
    end
  end

  context 'when the content has been cached' do
    let(:cached_value) { true }

    it 'displays cached false' do
      expect(page).to have_content('Cached: true')
    end
  end
end
