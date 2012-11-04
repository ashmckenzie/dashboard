class Internet

  def self.usage
    detail = {
      service_id: $APP_CONFIG.internet.service_id
    }

    uri_options = "%<service_id>s/usage"
    uri = URI.parse("#{$APP_CONFIG.internet.base_uri}/#{sprintf(uri_options, detail)}")
    uri.user = $APP_CONFIG.internet.user
    uri.password = $APP_CONFIG.internet.password

    response = XMLGet.request(uri.to_s)
    traffic = response.xpath('//internode/api/traffic')

    {
      :usage => traffic.text.to_i,
      :quota => traffic.attribute('quota').value.to_i
    }
  end
end
