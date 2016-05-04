require "spec_helper"

describe EA::AddressLookup do
  it { is_expected.to respond_to :find_by_postcode }
  it { is_expected.to respond_to :find_by_uprn }

  describe "find* methods delegate to the adpater" do
    # rubocop:disable Style/ClassAndModuleChildren
    class ::EA::AddressLookup::Adapters::TestAdapter; end
    # rubocop:enable Style/ClassAndModuleChildren

    %i(find_by_postcode find_by_uprn).each do |method|
      it "delegates #{method} to the adapter" do
        arg = "XXX"
        EA::AddressLookup.adapter = :test_adapter
        expect(EA::AddressLookup.adapter).to receive(method).with(arg)
        described_class.send(method, arg)
      end
    end
  end
end
