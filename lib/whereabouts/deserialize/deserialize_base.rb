# Base class for Deserializers - transform INBOUND data into
# data suitable to construct an Address instance
#
module Whereabouts
  module Deserialize
    class DeserializeBase
      def address_data(inbound)
        raise NotImplementedError, "No address_data implementation provided"
      end
    end
  end
end
