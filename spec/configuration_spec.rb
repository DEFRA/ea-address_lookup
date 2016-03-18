require 'spec_helper'

describe Whereabouts::Configuration do
  describe "#configure" do
    it 'can set and get configuration options' do
      Whereabouts.configure do |c|
        c.api_host = "a"
      end
      expect(Whereabouts.config.api_host).to eq "a"
    end
  end

  describe "#reset" do
    it 'clears down previously set configuration' do
      Whereabouts.configure { |c| c.api_host = "a" }
      Whereabouts.reset
      expect(Whereabouts.config.api_host).to be_nil
    end
  end
end
