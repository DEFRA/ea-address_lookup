require "ea/address_lookup/adapters/address_facade"

module EA::AddressLookup
  module Finders
    def find_by_postcode(post_code)
      adapter.find_by_postcode(post_code)
    end

    def find_by_uprn(uprn)
      adapter.find_by_uprn(uprn)
    end
  end
end
