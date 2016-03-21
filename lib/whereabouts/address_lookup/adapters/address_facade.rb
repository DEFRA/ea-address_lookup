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

module Whereabouts
  module AddressLookup
    module Adapters
      class AddressFacade
        attr_reader :server, :uri, :cid, :key

        def reset
          self.server = nil
          self.uri = nil
          self.cid = nil
          self.key = nil
        end

        def default_query_params
          {
            'client-id': Whereabouts.config.address_facade_client_id,
            'key': Whereabouts.config.address_facade_key
          }
        end

        def url
          @server ||= "http://#{Whereabouts.config.address_facade_server}:#{Whereabouts.config.address_facade_port}"
          @uri ||= URI.join(@server, Whereabouts.config.address_facade_url)
          @uri.to_s
        end

        def client_id
          @cid ||= Whereabouts.config.address_facade_client_id
        end

        def key
          @key ||= Whereabouts.config.address_facade_key
        end

        def raise_error(ex, message)
          raise Whereabouts::AddressServiceUnavailableError.new("Address by #{message} - #{ex.message}")
        end

        def find_by_uprn(uprn)

            Whereabouts.logger.info "Address search for UPRN [#{uprn}]"

            result = http_get(uprn)
            # http_address = url + "/#{uprn}"

            # # The AddressBaseFacade is internal within AWS, so we need to ensure that we DO NOT use a proxy
            # RestClient::Request.execute(method: :get, url: http_address, proxy: false,
            #   headers: {
            #     params: default_query_params
            #   })

          # rescue => e
          #   raise_error(e, "UPRN failed to reach server #{http_address}?client-id=#{client_id}&key=#{key}")
          # end

          parsed = begin
            JSON.parse(result)
          rescue => e
            Whereabouts.logger.error("Address by UPRN failed to parse JSON results")
            Whereabouts.logger.error(e.message.to_s)
            {}
          end

          Whereabouts.logger.info "Addresses for UPRN (#{uprn} [#{parsed.inspect}]"
          parsed
        end

        def find_by_postcode(post_code)
          # begin
            Whereabouts.logger.info "Address search for PostCode [#{post_code}]"

            #http_address = url + "/postcode"

            result = http_get("/postcode", postcode: post_code)

            # # The AddressBaseFacade is internal within AWS, so we need to ensure that we DO NOT use a proxy
            # result = RestClient::Request.execute(method: :get, url: http_address, proxy: false,
            #           headers: {
            #             params: { 'postcode': post_code }.merge(default_query_params)
            #           })

          # rescue => e
          #   raise_error(e, "PostCode failed to reach server #{http_address}?client-id=#{client_id}&key=#{key}")
          # end

          begin
            parsed = JSON.parse(result)
          rescue => e
            Whereabouts.logger.error("Address by PostCode failed to parse JSON results")
            Whereabouts.logger.error(e.message.to_s)
            parsed = {}
          end

          Whereabouts.logger.info "Addresses for PostCode (#{post_code}) [#{parsed.inspect}]"
          parsed
        end

        private
        attr_writer :server, :uri, :cid, :key

        def http_get(path, query_params = {})

          http_address = File.join(url, path)

          # The AddressBaseFacade is internal within AWS, so we need to ensure that we DO NOT use a proxy
          result = RestClient::Request.execute(
            method: :get,
            url: http_address, proxy: false,
            headers: {
              params: default_query_params.merge(query_params)
            })
          # rescue => e
          #   raise_error(e, "UPRN failed to reach server #{http_address}?client-id=#{client_id}&key=#{key}")
          #   raise Whereabouts::AddressServiceUnavailableError.new("Address by #{message} - #{ex.message}")
        end
      end
    end
  end
end
