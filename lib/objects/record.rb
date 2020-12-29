module Cloudflare
  class Record < Cloudflare::APIObject
    def initialize(data)
      super(data)
    end

    def proxy
      set_proxied(true)
    end

    def deproxy
      set_proxied(false)
    end

    private

    def set_proxied(to)
      @api.patch_to_json("zones/#{zone_id}/dns_records/#{id}", { proxied: to })
    end
  end
end
