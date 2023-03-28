class ForecastsController < ApplicationController
  def index
    @form = ForecastForm.new
  end

  def show
    @form = ForecastForm.new(permitted_forecast_params)

    if @form.valid?
      @forecast = Forecast.new(
        address: @form.address, city: @form.city, state: @form.state,
        zip_code: @form.zip_code
      )

      @forecast.fetch
    else
      render :index
    end
  end

  private

  def permitted_forecast_params
    params.require('forecast_form').permit(:address, :city, :state, :zip_code)
  end
end
