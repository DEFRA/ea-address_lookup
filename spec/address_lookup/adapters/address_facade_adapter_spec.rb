require "spec_helper"

describe Whereabouts::AddressLookup::Adapters::AddressFacade do

  def reset_address_config
  end

  describe "attributes are readable but not writable" do
    attrs = %i(server uri cid key)
    attrs.each {|att| it {is_expected.to respond_to(att) }}
    attrs.each {|att| it {is_expected.to_not respond_to("#{att}=".to_sym) }}
  end

  describe "Configuration and setup" do
    before(:all) do
      Whereabouts.configure do |config|
        config.address_facade_server = 'addressfacade.cloudapp.net'
        config.address_facade_port = ''
        config.address_facade_url = '/address-service/v1/addresses'
        config.address_facade_client_id = 'example team'
        config.address_facade_key = 'client1'
       end
     end
    let(:server)  { Whereabouts.config.address_facade_server }
    let(:port)    { Whereabouts.config.address_facade_port }
    let(:url)     { Whereabouts.config.address_facade_url }

    it "can be configured via Rails config" do
      expect(server).to_not be_nil
      expect(port).to be_instance_of String
      expect(url).to_not be_empty
    end

    it "provides access to full service url" do
      url =  subject.url
      expect(url.to_s).to include "http://"
      expect(url.to_s).to include server
    end

    describe "Finder methods" do
      it "can make a request to EA Facade for search on postcode" do
        VCR.use_cassette("find_by_postcode") do
          response = subject.find_by_postcode("BS6 5QA")
          expect(response).to be_an_instance_of(Hash)
          expect(response.has_key?("results")).to be true
          expect(response["results"]).to be_instance_of Array
          expect(response["results"].size).to be > 4
        end
      end

      it "can make a request to EA Facade for search on uprn" do
        VCR.use_cassette("find_by_uprn") do
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
    before(:each) do
      reset_address_config
    end

    let(:setup_bad_server) {
      Whereabouts.configure do |config|
        config.address_facade_server = "addressfacade.nosuchplaceinthewww.junk"
      end
    }

    let(:setup_bad_config) {
      Whereabouts.configure do |config|
        config.address_facade_key = "clientduffnaff"
      end
    }

    it "raises an exception when service cannot be reached for uprn search", focus: true do
      VCR.use_cassette("adaptor_no_such_server_uprn") do
        setup_bad_server
        byebug

        expect {
          subject.find_by_uprn("77138")
        }.to raise_error Whereabouts::AddressServiceUnavailableError
      end
    end

    it "raises an exception when service cannot be reached for postcode search" do
      VCR.use_cassette("adaptor_no_such_server_postcode") do
        setup_bad_server

        expect {
          subject.find_by_postcode("BS1 1AH")
        }.to raise_error Whereabouts::AddressServiceUnavailableError
      end
    end

    it "raises an exception when service config bad for UPRN" do
      VCR.use_cassette("adaptor_bad_config_uprn") do
        setup_bad_config

        expect {
          subject.find_by_uprn("77138")
        }.to raise_error Whereabouts::AddressServiceUnavailableError
      end
    end

    it "raises an exception when service config bad for Postcode" do
      VCR.use_cassette("adaptor_bad_config_postcode") do
        setup_bad_config

        expect {
          subject.find_by_postcode("BS1 1AH")
        }.to raise_error Whereabouts::AddressServiceUnavailableError
      end
    end

    after(:all) do
      reset_address_config
    end
  end
end
