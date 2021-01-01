require_relative 'object'

module CFC
  class Record < CFC::APIObject
    def proxy
      set_proxied(true)
    end

    def deproxy
      set_proxied(false)
    end

    private

    def set_proxied(to) # rubocop:disable Naming/AccessorMethodName
      @api.patch_to_json("zones/#{zone_id}/dns_records/#{id}", { proxied: to })
    end
  end
end
