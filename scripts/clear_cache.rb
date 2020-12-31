################################################################################
# clear_cache.rb
# 
# Clears *all* files from Cloudflare's cache from both codidact.com and
# codidact.org zones. Should be used when a stuck file (or multiple stuck files)
# in the cache are causing inconsistencies in user experience across the
# network and related assets. If you don't know what that means, ask someone
# who does before running this script.
#
# Relies on the existence of config.yml containing a Cloudflare API token.
# There's a sample config file with the correct keys in config.sample.yml.
#
# RUN:
# $ ruby clear_cache.rb
################################################################################

require 'yaml'
require_relative '../lib/cfc/objects/zone'

cfg = YAML.load_file(File.join(__dir__, 'config.yml'))

CFC::Config.configure do |config|
  config.token = cfg['token']
end

zones = CFC::Zone.list
codidact_zones = zones.select { |z| z.name.start_with?('codidact') && z.account.name == 'Codidact DNS' }
results = codidact_zones.map do |z|
  [z.name, z.purge_all_files]
end

if results.all? { |r| r[1]['success'] }
  puts "All caches purged successfully."
else
  puts "#{results.select { |r| r[1]['success'] }} succeeded"
  results.select { |r| !r[1]['success'] }.each do |f|
    puts "#{f[0]} failed"
    puts f[1]['errors']
    puts f[1]['messages']
  end
end
