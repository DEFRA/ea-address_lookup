require "spec_helper"
module EA
  module AddressLookup
    module TestHelper
      describe MockData do
        let(:mock_data) { described_class.new(:address_lookup) }
        let!(:address_facade) { Adapters::AddressFacade.new }

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

        let!(:uprn_response) do
          VCR.use_cassette("adapter_find_by_uprn") do
            address_facade.find_by_uprn("77138")
          end
        end

        let!(:postcode_response) do
          VCR.use_cassette("adapter_find_by_postcode") do
            address_facade.find_by_postcode("BS6 5QA")
          end
        end

        describe "#data_for" do
          context "with :uprn_lookup" do
            let(:data) { mock_data.data_for :uprn_lookup }

            it "should match the root keys" do
              expect(data.keys.sort).to eq(uprn_response.keys.sort)
            end

            it "should match results keys" do
              expect(data["results"].first.keys.sort)
                .to eq(uprn_response["results"].first.keys.sort)
            end
          end

          context "with :postcode_lookup" do
            let(:data) { mock_data.data_for :postcode_lookup }

            it "should match the root keys" do
              expect(data.keys.sort).to eq(postcode_response.keys.sort)
            end

            it "should match the root keys" do
              expect(data["results"].first.keys.sort)
                .to eq(postcode_response["results"].first.keys.sort)
            end
          end
        end
      end
    end
  end
end
