require 'rails_helper'

RSpec.describe ForecastsHelper do
  describe '#state_options' do
    before do
      stub_const('ForecastForm::VALID_STATES', %w[AA BB CC])
    end

    it 'returns the correct list' do
      expect(state_options).to contain_exactly(nil, 'AA', 'BB', 'CC')
    end
  end

  shared_context 'with a validated form' do
    let(:city) { 'Some City' }

    let(:form) do
      ForecastForm.new(
        address: '1234 Some Street',
        city:,
        state: ForecastForm::VALID_STATES.first,
        zip_code: '12345'
      )
    end

    before { form.validate }
  end

  describe '#form_field_error' do
    subject { form_field_error(form, :city) }

    include_context 'with a validated form'

    context 'when there are no form errors' do
      it { is_expected.to be_nil }
    end

    context 'when there are form errors' do
      let(:city) { nil }
      let(:err_msg) { "City can't be blank" }

      it { is_expected.to eq(err_msg) }
    end
  end

  describe '#generate_field_classes' do
    subject { generate_field_classes(form, :city, existing_classes) }

    let(:existing_classes) { 'example-class1 example-class2' }

    include_context 'with a validated form'

    context 'when there are no form errors' do
      it { is_expected.to eq(existing_classes) }
    end

    context 'when there are form errors' do
      let(:city) { nil }

      it { is_expected.to eq("#{existing_classes} is-invalid") }
    end
  end
end
