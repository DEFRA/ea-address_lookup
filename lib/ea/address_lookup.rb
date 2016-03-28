require "active_support/core_ext/string"
require "ea/address_lookup/version"
require "ea/address_lookup/configuration"
require "ea/address_lookup/logger"
require "ea/address_lookup/errors"
require "ea/address_lookup/adapters"
require "ea/address_lookup/finders"

module EA
  module AddressLookup
    extend Adapters
    extend Finders
  end
end
