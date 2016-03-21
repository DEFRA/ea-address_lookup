require "active_support/core_ext/string"
require "whereabouts/version"
require "whereabouts/configuration"
require "whereabouts/logger"
require "whereabouts/errors.rb"
require "whereabouts/address_lookup"

module Whereabouts
  extend self
  include AddressLookup
end
