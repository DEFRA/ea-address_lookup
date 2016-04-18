require "active_support/configurable"

module EA
  module AddressLookup
    class Configuration
      include ActiveSupport::Configurable
      config_accessor(:address_facade_server)
      config_accessor(:address_facade_port)
      config_accessor(:address_facade_url)
      config_accessor(:address_facade_client_id)
      config_accessor(:address_facade_key)
      config_accessor(:default_adapter) { :address_facade }
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield config
    end

    def self.reset
      @config = Configuration.new
    end
  end
end
