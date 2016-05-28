require "spec_helper"

module EA
  module AddressLookup
    module TestHelper
      describe RspecMocks do
        include TestHelper::RspecMocks

        before do
          EA::AddressLookup.adapter = :address_facade
        end

        describe "mock_ea_address_lookup_find_by_postcode" do
          it "if not invoked before #find_by_postcode, a VCR error raised" do
            expect { EA::AddressLookup.find_by_postcode("foobar") }
              .to raise_error(VCR::Errors::UnhandledHTTPRequestError)
          end
          it "if invoked before #find_by_postcode, mock data is returned" do
            mock_ea_address_lookup_find_by_postcode
            result = EA::AddressLookup.find_by_postcode("foobar")
            expect(result).to be_a(Hash)
          end
        end
      end
    end
  end
end
