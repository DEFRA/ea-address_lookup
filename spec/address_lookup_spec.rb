require 'spec_helper'

describe Whereabouts::AddressLookup do
  it { is_expected.to respond_to :find_by_postcode }
  it { is_expected.to respond_to :find_by_uprn }

  describe "#find_by_postcode" do
    it 'delegates to the adapter' do
      postcode = 'GL1 1AA'
      adapter_module = Whereabouts::Adapters.const_set(:TestAdapter, Module.new)
      Whereabouts::AddressLookup.adapter = :test_adapter
      expect(Whereabouts::Adapters::TestAdapter).to receive(:find_by_postcode).with(postcode)
      described_class.find_by_postcode(postcode)
    end
  end

  describe "#find_by_uprn" do
    it 'delegates to the adapter' do
    end
  end

  context "adapters" do
    describe "#adapter" do
    it "defaults to :address_facade" do
      pending
      expect(described_class.adapter).to eq(Whereabouts::Adapters::AddressFacade)
    end
  end

  describe "#adpater=" do
    it "assigns a matching adapter class" do
      Whereabouts::Adapters.const_set(:TestAdapter2, Module.new)
      described_class.adapter = :test_adapter2
      expect(described_class.adapter).to eq(Whereabouts::Adapters::TestAdapter2)
    end

    it "raises an error nil passed" do
      expect{ described_class.adapter = nil}.to raise_error(Whereabouts::MissingAdapterError)
    end

    it "raises an error if the adapter is not found" do
      expect{ described_class.adapter = :yay_mama}
        .to raise_error(Whereabouts::UnrecognisedAdapterError)
    end
  end
  end
end
