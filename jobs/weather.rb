require 'rest-client'
require 'json'
require 'uri'
require 'pry'
require 'hashie'

query = {
  country: 'AU',
  city: 'Melbourne'
}

base_uri = "http://api.wunderground.com/api/0bd4fdd3587a2caf/conditions/q/%<country>s/%<city>s.json"
uri = sprintf(base_uri, query)

SCHEDULER.every '5m', :first_in => 0 do |job|
  response = Hashie::Mash.new(JSON.parse(RestClient.get(uri)))

  observartion = response.current_observation
  location = observartion.display_location
  celsius = "&#8451;"

  weather = {
    location: {
      name: location.full,
      lat: location.latitude,
      lng: location.longitude
    },
    temperature: {
      current: "#{observartion.temp_c} #{celsius}"
    }
  }

  text = weather[:temperature][:current]

  send_event('weather', weather: weather, text: text)
end
