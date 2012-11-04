require 'rest-client'
require 'json'
require 'nokogiri'

class XMLGet

  def self.request uri, headers={}
    Nokogiri::XML(RestClient.get(uri.to_s, headers))
  end
end
