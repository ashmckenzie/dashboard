require 'rest-client'
require 'json'
require 'hashie'

class JSONGet

  def self.request uri, headers={}
    Hashie::Mash.new(JSON.parse(RestClient.get(uri.to_s, headers)))
  end
end
