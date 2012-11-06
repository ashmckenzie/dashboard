require 'uri'

module Weather

  class Yahoo

    def self.get location

      detail = {
        woeid: location.woeid
      }

      uri_options = "?w=%<woeid>s&u=c"
      uri = URI.parse("#{$APP_CONFIG.weather.base_uri}#{sprintf(uri_options, detail)}")

      response = XMLGet.request(uri.to_s)

      {
        location: {
          name: location.name,
          lat: response.xpath('//geo:lat').text.to_f,
          lng: response.xpath('//geo:long').text.to_f
        },
        temperature: {
          today: {
            current: response.xpath('//yweather:condition').attribute('temp').text,
            high: response.xpath('//yweather:forecast')[0].attribute('high').text,
            low: response.xpath('//yweather:forecast')[0].attribute('low').text
          },
          tomorrow: {
            high: response.xpath('//yweather:forecast')[1].attribute('high').text,
            low: response.xpath('//yweather:forecast')[1].attribute('low').text
          }
        }
      }
    end
  end
end
