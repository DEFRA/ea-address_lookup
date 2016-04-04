require "spec_helper"

describe EA::AddressLookup do
  describe "adapters" do
    describe "#adapter" do
      it "defaults to :address_facade" do
        expect(described_class.adapter).to_not be_nil
        expect(described_class.adapter.class)
          .to eq(EA::AddressLookup::Adapters::AddressFacade)
      end
    end

    describe "#adpater=" do
      class ::EA::AddressLookup::Adapters::TestAdapter2; end

      it "assigns a matching adapter class" do
        described_class.adapter = :test_adapter2
        expect(described_class.adapter.class)
          .to eq(EA::AddressLookup::Adapters::TestAdapter2)
      end

      it "raises an error nil passed" do
        expect { described_class.adapter = nil}
          .to raise_error(EA::AddressLookup::MissingAdapterError)
      end

      it "raises an error if the adapter is not found" do
        expect { described_class.adapter = :yay_mama }
          .to raise_error(EA::AddressLookup::UnrecognisedAdapterError)
      end
    end
  end
end
