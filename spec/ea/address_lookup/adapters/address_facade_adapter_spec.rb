require "spec_helper"
require "webmock/rspec"

describe EA::AddressLookup::Adapters::AddressFacade do
  before do
    EA::AddressLookup.configure do |config|
      config.address_facade_server = server # 'someaddressfacadeservice.net'
      config.address_facade_port = ""
      config.address_facade_url = url # '/address-service/v1/addresses/'
      config.address_facade_client_id = client_id # 'example team'
      config.address_facade_key = key # 'client1'
    end
  end
  let(:server)      { "someaddressfacadeservice.net" }
  let(:url)         { "/address-service/v1/addresses/" }
  let(:key)         { "client1" }
  let(:client_id)   { "example team1" }

  describe "Configuration and setup" do
    it "can be configured via Rails config" do
      expect(EA::AddressLookup.config.address_facade_server).to_not be_nil
      expect(EA::AddressLookup.config.address_facade_port)
        .to be_instance_of String
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
          expect(response.key?("results")).to be true
          expect(response["results"]).to be_instance_of Array
          expect(response["results"].size).to be > 4
        end
      end

      it "can make a request to EA Facade for search on uprn" do
        VCR.use_cassette("adapter_find_by_uprn") do
          response = subject.find_by_uprn("77138")
          expect(response).to be_an_instance_of(Hash)
          expect(response.key?("results")).to be true
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
        # An issue here: if you run this in the EA office, you get a 404;
        # if you run elsewhere, an ISP might return
        # a custom 404 page (with a 200 code) in which case, if using VCR,
        # the cassette is created is totally wrong.
        # There are ways you can disable the ISPs 404 for
        # example by setting custom DNS servers (e.g. Google's) in your router.
        # Anyway, for this reason we simulate a timeout here so the request is not
        # actually made - the gem traps the error and raises it as its own
        # type. This circumvents unpredictable dns/404 behaviour.
        # It may not be the optimum solution but its the best I have at the moment.
        # Note we take VCR out of the loop and stub the timeout with the underlying
        # webmock library as using a cassette is irrelevant here (and no cassette
        # is recorded if you just get a 404 anyway).
        # If you want to see what is actually returned by the network call,
        # insert a WebMock.allow_net_connect!
        VCR.turned_off do
          host = EA::AddressLookup.config.address_facade_server
          stub_request(:any, /.*#{host}.*/).to_timeout
          expect {
            subject.find_by_uprn("77138")
          }.to raise_error EA::AddressLookup::AddressServiceUnavailableError
        end
      end

      it "raises an exception when service unreachable for postcode search" do
        VCR.turned_off do
          host = EA::AddressLookup.config.address_facade_server
          stub_request(:any, /.*#{host}.*/).to_timeout
          expect {
            subject.find_by_postcode("77138")
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
