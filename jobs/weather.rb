MINUTES_IN_DAY = 1440
WEATHER_CONFIG = $CONFIG.weather

locations = WEATHER_CONFIG.locations
schedule_every = (((MINUTES_IN_DAY.to_f / WEATHER_CONFIG.max_calls_per_day.to_f).ceil * locations.length) * 2)

SCHEDULER.every "#{schedule_every}m", :first_in => 0 do |job|

  locations.each do |location|
    current_weather = Weather.current location.country_code, location.city
    forecast_weather = Weather.forecast location.country_code, location.city
    data_id = "weather-#{location.city.downcase.gsub(/[^\w]+/, '-')}"
    send_event(data_id, weather: current_weather, forecast: forecast_weather)
  end
end
