require "spec_helper"

describe EA::AddressLookup::Adapters::AddressFacade do
  before do
    EA::AddressLookup.configure do |config|
      config.address_facade_server = server #'addressfacade.cloudapp.net'
      config.address_facade_port = ""
      config.address_facade_url = url# '/address-service/v1/addresses/'
      config.address_facade_client_id = client_id# 'example team'
      config.address_facade_key = key # 'client1'
    end
  end
  let(:server)      { "addressfacade.cloudapp.net" }
  let(:url)         { "/address-service/v1/addresses/" }
  let(:key)         { "client1" }
  let(:client_id)   { "example team1" }

  describe "Configuration and setup" do
    it "can be configured via Rails config" do
      expect(EA::AddressLookup.config.address_facade_server).to_not be_nil
      expect(EA::AddressLookup.config.address_facade_port).to be_instance_of String
      expect(EA::AddressLookup.config.address_facade_url).to_not be_empty
    end

    it "provides access to full service url" do
      url1 = subject.base_url
      expect(url1.to_s).to include "http://"
      expect(url1.to_s).to include server
    end

    describe "Finder methods" do
      it "can make a request to EA Facade for search on postcode" do
        VCR.use_cassette("adapter_find_by_postcode") do
          response = subject.find_by_postcode("BS6 5QA")
          expect(response).to be_an_instance_of(Hash)
          expect(response.has_key?("results")).to be true
          expect(response["results"]).to be_instance_of Array
          expect(response["results"].size).to be > 4
        end
      end

      it "can make a request to EA Facade for search on uprn" do
        VCR.use_cassette("adapter_find_by_uprn") do
          response = subject.find_by_uprn("77138")
          expect(response).to be_an_instance_of(Hash)
          expect(response.has_key?("results")).to be true
          expect(response["results"]).to be_instance_of Array
          expect(response["results"].size).to be 1
        end
      end
    end
  end

  describe "service down", fails: true do
    let(:setup_bad_server) {
      EA::AddressLookup.configure do |config|
        config.address_facade_server = "addressfacade.nosuchplaceinthewww.junk"
      end
    }

    let(:setup_bad_config) {
      EA::AddressLookup.configure do |config|
        config.address_facade_key = "clientduffnaff"
      end
    }

    context "bad server" do
      let(:server) { "addressfacade.nosuchplaceinthewww.junk" }
      it "raises an exception when service cannot be reached for uprn search" do
        VCR.use_cassette("adaptor_no_such_server_uprn") do
          expect {
            subject.find_by_uprn("77138")
          }.to raise_error EA::AddressLookup::AddressServiceUnavailableError
        end
      end

      it "raises an exception when service cannot be reached for postcode search" do
        VCR.use_cassette("adaptor_no_such_server_postcode") do
          expect {
            subject.find_by_postcode("BS1 1AH")
          }.to raise_error EA::AddressLookup::AddressServiceUnavailableError
        end
      end
    end

    context "bad key" do
      let(:key) { "clientduffnaff" }

      it "raises an exception when service config bad for UPRN" do
        VCR.use_cassette("adaptor_bad_config_uprn") do
          expect {
            subject.find_by_uprn("77138")
          }.to raise_error EA::AddressLookup::AddressServiceUnavailableError
        end
      end
    end

    it "raises an exception when service config bad for Postcode" do
      VCR.use_cassette("adaptor_bad_config_postcode") do
        setup_bad_config
        expect {
          subject.find_by_postcode("BS1 1AH")
        }.to raise_error EA::AddressLookup::AddressServiceUnavailableError
      end
    end

    it "returns an empty hash and logs an error if the json cannot be parsed" do
      EA::AddressLookup.logger = Logger.new("/dev/null")
      VCR.use_cassette("adaptor_bad_json_response") do
        result = subject.find_by_postcode("BS1 1AH")
        expect(result).to eq({})
      end
    end
  end
end
