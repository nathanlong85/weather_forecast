module ForecastsHelper
  def state_options
    [nil] + ForecastForm::VALID_STATES
  end

  def form_field_error(form, field)
    form.object.errors.where(field).first&.full_message
  end

  # Will add the `is-invalid` error class if necessary
  def generate_classes(form, field, existing_classes)
    if form.object.errors.where(field).empty?
      existing_classes
    else
      "#{existing_classes} is-invalid"
    end
  end
end
