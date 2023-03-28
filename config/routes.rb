Rails.application.routes.draw do
  root 'forecasts#index'

  # Not using resourceful routing because it doesn't really
  # make sense for this application
  get 'forecast', to: 'forecasts#show'
end
