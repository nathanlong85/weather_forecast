# frozen_string_literal: true

# Disable the default <div class="field_with_errors"> wrapped around
# form fields with errors in the views
ActionView::Base.field_error_proc = proc { |html_tag| html_tag }
