require 'rest-client'
require 'json'
require 'hashie'
require 'uri'

class Weather

  CELSIUS_SYMBOL = "&#8451;"
  BASE_URI = "http://api.wunderground.com/api"

  def self.lookup country_code, city

    detail = {
      country: URI.escape(country_code),
      city: URI.escape(city),
      api_key: $CONFIG.weather.api_key
    }

    uri_options = "%<api_key>s/conditions/q/%<country>s/%<city>s.json"
    uri = URI.parse("#{BASE_URI}/#{sprintf(uri_options, detail)}")

    response = Hashie::Mash.new(JSON.parse(RestClient.get(uri.to_s)))

    observartion = response.current_observation
    location = observartion.display_location

    {
      location: {
        name: location.full,
        lat: location.latitude,
        lng: location.longitude
      },
      temperature: {
        current: "#{observartion.temp_c} #{CELSIUS_SYMBOL}"
      }
    }
  end
end
