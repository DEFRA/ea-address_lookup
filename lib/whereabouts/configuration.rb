# module Whereabouts
#   class Configuration
#     attr_accessor :api_host

#     def initialize
#     end
#   end

#   class << self
#     attr_writer :configuration
#   end

#   def self.configuration
#     @configuration ||= Configuration.new
#   end

#   def self.reset
#     @configuration = Configuration.new
#   end

#   def self.configure
#     yield(configuration)
#   end
# end

require "active_support/configurable"
module Whereabouts
  class Configuration
    include ActiveSupport::Configurable

    # Define accessors and optional defaults
    config_accessor(:api_host)
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
