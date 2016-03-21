require "whereabouts/address_lookup/adapters/address_facade"

module Whereabouts
  module AddressLookup
    extend self
    def find_by_postcode(post_code)
      adapter.find_by_postcode(post_code)
    end

    def find_by_uprn(uprn)
      adapter.find_by_uprn(uprn)
    end

    def adapter
      return @adapter if @adapter
      self.adapter = :address_facade # the default adaptor
      @adapter
    end

    def adapter=(adapter_name)
      raise MissingAdapterError if adapter_name.blank?
      raise MissingAdapterError unless adapter_name.is_a?(String) || adapter_name.is_a?(Symbol)

      adapter_klass = adapter_name.to_s.classify.to_s
      @adapter = Adapters.const_get(adapter_klass).new

    rescue NameError => ex
      raise UnrecognisedAdapterError, adapter_name
    end
  end
end
