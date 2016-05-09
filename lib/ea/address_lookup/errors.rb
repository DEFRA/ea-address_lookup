require "nesty"

module EA
  module AddressLookup
    class MissingAdapterError < StandardError
      include Nesty::NestedError
    end
    class UnrecognisedAdapterError < StandardError
      include Nesty::NestedError
    end
    class AddressServiceUnavailableError < StandardError
      include Nesty::NestedError
    end
  end
end
