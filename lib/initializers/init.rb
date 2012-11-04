require 'yaml'
require 'hashie'

config_file = File.expand_path('../../../config/config.yml', __FILE__)

if File.exist?(config_file)
  $CONFIG = Hashie::Mash.new YAML.load_file(config_file)
end
