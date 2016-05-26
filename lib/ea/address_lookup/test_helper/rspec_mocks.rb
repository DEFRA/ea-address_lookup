require_relative "mock_data"
module EA
  module AddressLookup
    module TestHelper
      # Uses data from address_lookup.yml to mock calls to EA::AddressLookup methods
      module RspecMocks

        def mock_ea_address_lookup_find_by_uprn
          allow(EA::AddressLookup)
            .to receive(:find_by_uprn)
            .and_return(mock_data.data_for(:uprn_lookup))
        end

        def mock_failure_of_ea_address_lookup_find_by_uprn
          allow(EA::AddressLookup)
            .to receive(:find_by_uprn)
            .and_raise(AddressServiceUnavailableError, "Whoops")
        end

        def mock_ea_address_lookup_find_by_postcode
          allow(EA::AddressLookup)
            .to receive(:find_by_postcode)
            .and_return(mock_data.data_for(:postcode_lookup))
        end

        def mock_failure_of_ea_address_lookup_find_by_postcode
          allow(EA::AddressLookup)
            .to receive(:find_by_postcode)
            .and_raise(AddressServiceUnavailableError, "Whoops")
        end

        private

        def mock_data
          @mock_data ||= MockData.new :address_lookup
        end

      end
    end
  end
end
