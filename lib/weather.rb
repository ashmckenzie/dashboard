require 'uri'

class Weather

  def self.current country_code, city

    detail = {
      country: URI.escape(country_code),
      city: URI.escape(city),
      api_key: $CONFIG.weather.api_key
    }

    uri_options = "%<api_key>s/conditions/q/%<country>s/%<city>s.json"
    uri = URI.parse("#{$CONFIG.weather.base_uri}/#{sprintf(uri_options, detail)}")

    response = JSONGet.request(uri.to_s)

    observartion = response.current_observation
    location = observartion.display_location

    {
      location: {
        name: location.full,
        lat: location.latitude,
        lng: location.longitude
      },
      temperature: {
        current: observartion.temp_c
      }
    }
  end

  def self.forecast country_code, city

    detail = {
      country: URI.escape(country_code),
      city: URI.escape(city),
      api_key: $CONFIG.weather.api_key
    }

    uri_options = "%<api_key>s/forecast/q/%<country>s/%<city>s.json"
    uri = URI.parse("#{$CONFIG.weather.base_uri}/#{sprintf(uri_options, detail)}")

    response = JSONGet.request(uri.to_s)

    forecast = {}

    response.forecast.simpleforecast.forecastday.each do |day|
      if day.date.weekday != Time.now.strftime('%A')
        forecast = day
        break
      end
    end

    {
      high: forecast.high.celsius,
      low: forecast.low.celsius
    }
  end
end
