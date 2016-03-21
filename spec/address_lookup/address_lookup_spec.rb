require "spec_helper"

describe Whereabouts::AddressLookup do
  it { is_expected.to respond_to :find_by_postcode }
  it { is_expected.to respond_to :find_by_uprn }

  describe "find* methods delegate to the adpater" do
    class ::Whereabouts::Adapters::TestAdapter; end
    %i(find_by_postcode find_by_uprn).each do |method|
      it "delegates #{method} to the adapter" do
        arg = "XXX"
        Whereabouts::AddressLookup.adapter = :test_adapter
        expect(Whereabouts::AddressLookup.adapter).to receive(method).with(arg)
        described_class.send(method, arg)
      end
    end
  end
end
