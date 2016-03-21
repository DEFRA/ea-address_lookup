require "spec_helper"

describe Whereabouts::AddressLookup do

  describe "adapters" do

    describe "#adapter" do
      it "defaults to :address_facade" do
        expect(described_class.adapter).to_not be_nil
        expect(described_class.adapter.class).to eq(Whereabouts::Adapters::AddressFacade)
      end
    end

    describe "#adpater=" do
      class ::Whereabouts::Adapters::TestAdapter2; end

      it "assigns a matching adapter class" do
        described_class.adapter = :test_adapter2
        expect(described_class.adapter.class).to eq(Whereabouts::Adapters::TestAdapter2)
      end

      it "raises an error nil passed" do
        expect { described_class.adapter = nil}.to raise_error(Whereabouts::MissingAdapterError)
      end

      it "raises an error if the adapter is not found" do
        expect { described_class.adapter = :yay_mama }
          .to raise_error(Whereabouts::UnrecognisedAdapterError)
      end
    end
  end
end
