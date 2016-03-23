# Adaptor for EA AddressFacade :
#
# Relies on the following configuration options:
#
#   :address_facade_server
#   :address_facade_port
#   :address_facade_url
#   :address_facade_client_id
#   :address_facade_key
#
# Testing The Service
#
# The service is a simple rest service and can be tested using any browser
# or the curl command from a Unix command line:
#
# ## Match By String
#
# N.B '\ char is ruby string continue - not part of the URL

# curl http://servername:port/address-service/v1/addresses/find?\
# client-id=example%20team&201&key=client1&query-string=buckingham%20palace
#
# ## Search Post Code
#
# curl http://servername:port/address-service/v1/addresses/postcode?\
# client-id=example%20team&201&key=key1&postcode=bs1%205ah
#
# It also comes with a swagger interface, which can also visit via your locally
# running server @ http://localhost:9002/swagger
#
require "rest_client"
require "benchmark"

module EA::AddressLookup
  module Adapters
    class AddressFacade
      attr_reader :base_url

      def reset
        @base_url = nil
      end

      def base_url
        @base_url ||= begin
          host = "http://#{EA::AddressLookup.config.address_facade_server}:#{EA::AddressLookup.config.address_facade_port}"
          URI.join(host, EA::AddressLookup.config.address_facade_url || '').to_s
        end
      end

      def find_by_uprn(uprn)
        with_logging(:find_by_uprn, uprn) do
          result = http_get(uprn)
          parsed = parse_json(result)
        end
      end

      def find_by_postcode(post_code)
        with_logging(:find_by_postcode, post_code) do
          result = http_get("postcode", postcode: post_code)
          parsed = parse_json(result)
        end
      end

      private

      def default_query_params
        {
          'client-id': EA::AddressLookup.config.address_facade_client_id,
          'key': EA::AddressLookup.config.address_facade_key
        }
      end

      def http_get(path, query_params = {})
        http_address = URI.join(base_url, path).to_s
        # The AddressBaseFacade is internal within AWS, so we need to ensure that we DO NOT use a proxy
        result = RestClient::Request.execute(
          method: :get,
          url: http_address,
          proxy: false,
          headers: {
            params: default_query_params.merge(query_params)
          })
        rescue => ex
          raise ex if ex.class.to_s.match /^VCR/
          raise EA::AddressLookup::AddressServiceUnavailableError,
                "#{http_address} params:#{ default_query_params.merge(query_params)} - #{ex.message}"
      end

      def parse_json(json)
        JSON.parse(json)
      rescue => e
        EA::AddressLookup.logger.error("Failed to parse JSON results #{e.message} #{json}")
        {}
      end

      def with_logging(scope, arg, &block)
        parsed_result = nil
        time = Benchmark.realtime do
          parsed_result = block.call
        end
        EA::AddressLookup.logger.info "#{scope}(#{arg}) took #{sprintf("%05.2fms", time * 1000)}"
        EA::AddressLookup.logger.debug "#{scope}(#{arg}) result #{parsed_result}"
        parsed_result
      end
    end
  end
end