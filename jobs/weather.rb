require 'rest-client'
require 'json'
require 'hashie'

exit unless $CONFIG.weather

MINUTES_IN_DAY = 1440
CELSIUS_SYMBOL = "&#8451;"
WEATHER_CONFIG = $CONFIG.weather

detail = {
  country: WEATHER_CONFIG.lookup.country_code,
  city: WEATHER_CONFIG.lookup.city,
  api_key: WEATHER_CONFIG.api_key
}

schedule_every =  (MINUTES_IN_DAY.to_f / WEATHER_CONFIG.max_calls_per_day.to_f).ceil

base_uri = "http://api.wunderground.com/api/%<api_key>s/conditions/q/%<country>s/%<city>s.json"
uri = sprintf(base_uri, detail)

SCHEDULER.every "#{schedule_every}m", :first_in => 0 do |job|
  response = Hashie::Mash.new(JSON.parse(RestClient.get(uri)))

  observartion = response.current_observation
  location = observartion.display_location

  weather = {
    location: {
      name: location.full,
      lat: location.latitude,
      lng: location.longitude
    },
    temperature: {
      current: "#{observartion.temp_c} #{CELSIUS_SYMBOL}"
    }
  }

  send_event('weather', weather: weather)
end
