require 'uri'

module Weather

  class Wunderground

    def self.get location

      current = self.current(location.country_code, location.city)
      forecast = self.forecast(location.country_code, location.city)

      {
        location: {
          name: location.name,
          lat: current.current_observation.display_location.latitude.to_f,
          lng: current.current_observation.display_location.longitude.to_f
        },
        temperature: {
          today: {
            current: current.current_observation.temp_c,
            high: forecast.forecast.simpleforecast.forecastday[0].high.celsius,
            low: forecast.forecast.simpleforecast.forecastday[0].low.celsius
          },
          tomorrow: {
            high: forecast.forecast.simpleforecast.forecastday[1].high.celsius,
            low: forecast.forecast.simpleforecast.forecastday[1].low.celsius
          }
        }
      }
    end

    private

    def self.current country_code, city

      detail = {
        country: URI.escape(country_code),
        city: URI.escape(city),
        api_key: $APP_CONFIG.weather.api_key
      }

      uri_options = "%<api_key>s/conditions/q/%<country>s/%<city>s.json"
      uri = URI.parse("#{$APP_CONFIG.weather.base_uri}/#{sprintf(uri_options, detail)}")

      JSONGet.request(uri.to_s)
    end

    def self.forecast country_code, city

      detail = {
        country: URI.escape(country_code),
        city: URI.escape(city),
        api_key: $APP_CONFIG.weather.api_key
      }

      uri_options = "%<api_key>s/forecast/q/%<country>s/%<city>s.json"
      uri = URI.parse("#{$APP_CONFIG.weather.base_uri}/#{sprintf(uri_options, detail)}")

      JSONGet.request(uri.to_s)
    end
  end
end
