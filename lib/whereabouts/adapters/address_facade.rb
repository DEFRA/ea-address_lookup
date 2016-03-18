# Adaptor for EA AddressFacade :
#
# Configuration :
#
# See : config/initializers/digital_services_core_config.rb
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

module Whereabouts
  module Adapters
    module AddressFacade
      extend self

      attr_writer :server, :uri, :cid, :key

      def reset
        @server = nil
        @uri = nil
        @cid = nil
        @key = nil
      end

      def url
        @server ||= "http://#{DigitalServicesCore.address_facade_server}:#{DigitalServicesCore.address_facade_port}"
        @uri ||= URI.join(@server, DigitalServicesCore.address_facade_url)
        Rails.logger.debug "Address Lookup URL (#{@uri})"
        @uri.to_s
      end

      def client_id
        @cid ||= DigitalServicesCore.address_facade_client_id
      end

      def key
        @key ||= DigitalServicesCore.address_facade_key
      end

      def raise_error(ex, message)
        raise DigitalServicesCore::AddressServiceNA.new("Address by #{message} - #{ex.message}")
      end

      def find_by_uprn(uprn)
        result = begin
          Rails.logger.info "Address search for UPRN [#{uprn}]"

          http_address = url + "/#{uprn}"

          # The AddressBaseFacade is internal within AWS, so we need to ensure that we DO NOT use a proxy
          RestClient::Request.execute(method: :get, url: http_address, proxy: false,
            headers: {
              params: {
                'client-id': client_id,
                'key': key
              }
            })

        rescue => e
          raise_error(e, "UPRN failed to reach server #{http_address}?client-id=#{client_id}&key=#{key}")
        end

        parsed = begin
          JSON.parse(result)
        rescue => e
          Rails.logger.error("Address by UPRN failed to parse JSON results")
          Rails.logger.error(e.message.to_s)
          {}
        end

        Rails.logger.info "Addresses for UPRN (#{uprn} [#{parsed.inspect}]"
        parsed
      end

      def find_by_postcode(post_code)
        begin
          Rails.logger.info "Address search for PostCode [#{post_code}]"

          http_address = url + "/postcode"

          # The AddressBaseFacade is internal within AWS, so we need to ensure that we DO NOT use a proxy
          result = RestClient::Request.execute(method: :get, url: http_address, proxy: false,
                    headers: {
                      params: {
                        'client-id': client_id,
                        'key': key,
                        'postcode': post_code
                      }
                    })

        rescue => e
          raise_error(e, "PostCode failed to reach server #{http_address}?client-id=#{client_id}&key=#{key}")
        end

        begin
          parsed = JSON.parse(result)
        rescue => e
          Rails.logger.error("Address by PostCode failed to parse JSON results")
          Rails.logger.error(e.message.to_s)
          parsed = {}
        end

        Rails.logger.info "Addresses for PostCode (#{post_code}) [#{parsed.inspect}]"
        parsed
      end
    end
  end
end
