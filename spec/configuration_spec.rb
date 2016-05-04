require "spec_helper"

describe EA::AddressLookup::Configuration do
  let(:config) { EA::AddressLookup.config }

  it { is_expected.to respond_to(:default_adapter) }

  describe "#configure" do
    it "can set and get configuration options" do
      EA::AddressLookup.configure do |c|
        c.address_facade_server = "a"
        c.address_facade_port = "b"
        c.address_facade_url = "c"
        c.address_facade_client_id = "d"
        c.address_facade_key = "e"
      end
      expect(config.address_facade_server).to eq "a"
      expect(config.address_facade_port).to eq "b"
      expect(config.address_facade_url).to eq "c"
      expect(config.address_facade_client_id).to eq "d"
      expect(config.address_facade_key).to eq "e"
    end
  end

  describe "#reset" do
    it "clears down previously set configuration" do
      EA::AddressLookup.configure { |c| c.address_facade_port = "a" }
      EA::AddressLookup.reset
      expect(config.address_facade_port).to be_nil
    end
  end

  describe "defaults" do
    it "has a default_adapter" do
      expect(config.default_adapter).to_not be_blank
    end
  end
end
