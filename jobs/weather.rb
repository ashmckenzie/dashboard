WEATHER_CONFIG = $APP_CONFIG.weather

SCHEDULER.every WEATHER_CONFIG.refresh, :first_in => 0 do |job|

  WEATHER_CONFIG.locations.each do |location|
    weather = Weather::Yahoo.get location
    data_id = "weather-#{location.name.downcase.gsub(/[^\w]+/, '-')}"
    send_event(data_id, weather: weather)
  end
end
