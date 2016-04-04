# The specific wrapper class for the address lookup API
# is wired up using the Adapter patter. This allows us to present a common
# interface to potentially varying address api interfaces.
require "ea/address_lookup/adapters/address_facade"

module EA::AddressLookup
  module Adapters
    def adapter
      @adapter ||= create_adapter(EA::AddressLookup.config.default_adapter)
    end

    def adapter=(adapter_name)
      @adapter = create_adapter(adapter_name)
    end

    private

    # Given an adpater_nam of e.g. :address_facade, return an instance of
    # EA::AddressLookup::AddressLookup::Adapters::AddressFacade
    def create_adapter(adapter_name)
      raise MissingAdapterError if adapter_name.blank?

      adapter_klass = adapter_name.to_s.classify.to_s
      Adapters.const_get(adapter_klass).new

    rescue NameError => ex
      raise UnrecognisedAdapterError, adapter_name
    end
  end
end
