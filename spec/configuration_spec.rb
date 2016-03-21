require "spec_helper"

describe Whereabouts::Configuration do

  it {is_expected.to respond_to(:address_facade_server) }
  it {is_expected.to respond_to(:address_facade_port) }

  describe "#configure" do
    it "can set and get configuration options" do
      Whereabouts.configure do |c|
        c.address_facade_server = "a"
        c.address_facade_port = "b"
        c.address_facade_url = "c"
        c.address_facade_client_id = "d"
        c.address_facade_key = "e"
      end
      expect(Whereabouts.config.address_facade_server).to eq "a"
      expect(Whereabouts.config.address_facade_port).to eq "b"
      expect(Whereabouts.config.address_facade_url).to eq "c"
      expect(Whereabouts.config.address_facade_client_id).to eq "d"
      expect(Whereabouts.config.address_facade_key).to eq "e"
    end
  end

  describe "#reset" do
    it "clears down previously set configuration" do
      Whereabouts.configure { |c| c.address_facade_port = "a" }
      Whereabouts.reset
      expect(Whereabouts.config.address_facade_port).to be_nil
    end
  end
end
