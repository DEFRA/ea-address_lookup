module EA
  module AddressLookup
    class MissingAdapterError < StandardError; end
    class UnrecognisedAdapterError < StandardError; end
    class AddressServiceUnavailableError < StandardError; end
  end
end
