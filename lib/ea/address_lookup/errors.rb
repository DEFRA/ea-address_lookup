module EA::AddressLookup
  class MissingAdapterError < StandardError; end
  class UnrecognisedAdapterError < StandardError; end
  class AddressServiceUnavailableError < StandardError; end
end
