require 'rest-client'
require 'json'
require 'hashie'

exit unless $CONFIG.weather

MINUTES_IN_DAY = 1440
WEATHER_CONFIG = $CONFIG.weather

locations = WEATHER_CONFIG.locations
schedule_every = (MINUTES_IN_DAY.to_f / WEATHER_CONFIG.max_calls_per_day.to_f).ceil * locations.length

SCHEDULER.every "#{schedule_every}m", :first_in => 0 do |job|
  locations.each do |location|
    weather = Weather.lookup location.country_code, location.city
    data_id = "weather-#{location.city.downcase.gsub(/[^\w]+/, '-')}"
    send_event(data_id, weather: weather)
  end
end
