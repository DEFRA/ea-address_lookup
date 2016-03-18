require "whereabouts/version"
require "whereabouts/configuration"
require "whereabouts/errors.rb"
require "whereabouts/address_lookup"
require "active_support/core_ext/string"

module Whereabouts
  extend self
  include AddressLookup
end
