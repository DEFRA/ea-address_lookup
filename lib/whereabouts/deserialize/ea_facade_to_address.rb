# Specific converter - convert EA AddressFacade into other usable forms
#
require_relative "deserialize_base"

module Whereabouts
  module Deserialize
    class EaFacadeToAddress < Deserialize::DeserializeBase

      def selectable_address_data(inbound)
        addresses = inbound["results"] if(inbound)

        addresses ||= []

        results = addresses.collect do |a|
          {
            moniker: a["address"],
            uprn: a["uprn"]
          }
        end

        results
      end

      # Builds collection of attributes in correct format to simply
      # pass to Address new or create - to build an Address (plus Location)
      def address_data(inbound)
        addresses = inbound["results"] if(inbound)

        addresses ||= []

        results = addresses.collect do |a|
          a.default = ""

          {
            premises: a["premises"],
            street_address: a["street_address"],
            locality: a["locality"],
            city: a["city"],
            postcode: a["postcode"],

            organisation: a["organisation"] || "",
            state_date: a["state_date"],

            # currently no data/mapping available - awaiting address facade docs and no firm reqmnts for storage

            blpu_state_code: a["blpu_state_code"],
            postal_address_code: a["postal_address_code"],
            logical_status_code: a["logical_status_code"],

            location_attributes:
              {
                grid_reference: nil,
                uprn: a["uprn"],
                lat: nil,
                long: nil,
                x: EaFacadeToAddress.format_xy(a["x"]),
                y: EaFacadeToAddress.format_xy(a["y"]),
                coordinate_system: a["coordinate_system"],
              }
          }
        end

        results
      end

      def self.format_xy(inbound)
        return inbound if(inbound.blank?)
        # the format can contain leading 0 so have to treat f,d as a string
        f, d = inbound.split(".")
        "#{f.rjust(6, '0')}.#{d || 0}" # handle strings with or without a '.'
      end
    end
  end
end
