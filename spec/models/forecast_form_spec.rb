# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ForecastForm do
  subject(:forecast_form) do
    described_class.new(address:, city:, state:, zip_code:)
  end

  # Default valid values. Will be overridden by examples when required
  let(:address) { '12345 Some Street' }
  let(:city) { 'Some City' }
  let(:state) { described_class::VALID_STATES.first }
  let(:zip_code) { '12345' }

  context 'when address is missing' do
    let(:address) { nil }

    it { is_expected.not_to be_valid }
  end

  context 'when city is missing' do
    let(:city) { nil }

    it { is_expected.not_to be_valid }
  end

  context 'when state is missing' do
    let(:state) { nil }

    it { is_expected.not_to be_valid }
  end

  context 'when state is an invalid value' do
    let(:state) { 'IR' }

    it { is_expected.not_to be_valid }
  end

  context 'when zip_code is missing' do
    let(:zip_code) { nil }

    it { is_expected.not_to be_valid }
  end

  context 'when zip_code is an invalid value' do
    let(:zip_code) { '123' }

    let(:i18n_path) do
      'activemodel.errors.models.forecast_form.attributes.zip_code.invalid'
    end

    it 'is invalid with the correct error message' do
      forecast_form.validate

      expect(forecast_form.errors.where(:zip_code).first.full_message)
        .to eq("Zip code #{I18n.t(i18n_path)}")
    end
  end

  context 'when all values are valid' do
    context 'when zip_code is a 5-digit value' do
      it { is_expected.to be_valid }
    end

    context 'when zip_code is a 9-digit value' do
      let(:zip_code) { '12345-6789' }

      it { is_expected.to be_valid }
    end
  end
end
