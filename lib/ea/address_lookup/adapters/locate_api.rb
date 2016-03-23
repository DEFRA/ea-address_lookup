#
# Example of how me might define an Adaptor for https://github.com/alphagov/locate-api
#
module EA::AddressLookup
  module Adapters
    module LocateApi
      extend self

      def url
        Rails.configuration.dcs_locate_api_url
      end

      def find_by_postcode(post_code)
        result = []
        begin
          res = RestClient::Request.execute(method: :get,
                                            url: url,
                                            proxy: false,
                                            params: { postcode: post_code })

          result = JSON.parse(res)
        rescue => e
          EA::AddressLookup.logger.debug e
          result = []
        end
        result
      end
    end
  end
end
