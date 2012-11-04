require 'pry'

class Internet

  def self.usage
    detail = {
      service_id: $CONFIG.internet.service_id
    }

    uri_options = "%<service_id>s/usage"
    uri = URI.parse("#{$CONFIG.internet.base_uri}/#{sprintf(uri_options, detail)}")
    uri.user = $CONFIG.internet.user
    uri.password = $CONFIG.internet.password

    response = XMLGet.request(uri.to_s)
    traffic = response.xpath('//internode/api/traffic')

    {
      :usage => traffic.text.to_i,
      :quota => traffic.attribute('quota').value.to_i
    }
  end
end
