################################################################################
# clear_cache.rb
# 
# Clears *all* files from Cloudflare's cache from both codidact.com and
# codidact.org zones. Should be used when a stuck file (or multiple stuck files)
# in the cache are causing inconsistencies in user experience across the
# network and related assets. If you don't know what that means, ask someone
# who does before running this script.
#
# RUN:
# $ ruby clear_cache.rb
################################################################################

require_relative '../lib/objects/zone'

zones = Cloudflare::Zone.list
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
