require 'yaml'
require 'hashie'

config_file = File.expand_path('../../../config/config.yml', __FILE__)

raise "Ensure you have #{config_file} setup" unless File.exist?(config_file)

$CONFIG = Hashie::Mash.new YAML.load_file(config_file)
$APP_CONFIG = $CONFIG.app
