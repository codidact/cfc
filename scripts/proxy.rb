################################################################################
# proxy.rb
#
# Sets all Codidact community records to either proxied or deproxied, based on
# the command-line arguments provided. It's necessary to deproxy all communities
# before a new community is created so that a TLS certificate can be correctly
# issued, and then to reproxy the records afterwards.
#
# Relies on the existence of config.yml containing a Cloudflare API token.
# There's a sample config file with the correct keys in config.sample.yml.
#
# RUN:
# $ ruby proxy.rb (--proxy|--deproxy)
################################################################################

require 'yaml'
require 'net/http'
require 'json'
require_relative '../lib/cfc/objects/zone'

cfg = YAML.load_file(File.join(__dir__, 'config.yml'))

CFC::Config.configure do |config|
  config.token = cfg['token']
end

if ARGV.size < 1
  puts "One of --proxy or --deproxy is required!"
  exit 1
end

set_proxied = ARGV[0] == '--proxy'

communities_data = JSON.parse(Net::HTTP.get(URI('https://codidact.com/communities.json')))
record_names = communities_data.map { |c| "#{c['url_slug']}.codidact.com" }

zones = CFC::Zone.list
zone = zones.select { |z| z.account.name == 'Codidact DNS' && z.name == 'codidact.com' }[0]

zone.records.each do |r|
  next unless record_names.include? r.name
  if set_proxied
    r.proxy
    puts "#{r.name}: proxied"
  else
    r.deproxy
    puts "#{r.name}: deproxied"
  end
end
