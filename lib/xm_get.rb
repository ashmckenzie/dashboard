require 'rest-client'
require 'json'
require 'nokogiri'
require 'pry'

class XMLGet

  def self.request uri, headers={}
    response = RestClient.get(uri.to_s, headers)
    Nokogiri::XML(response)
  end
end
