# A consumer can hook into logging like so:
#   EA::AddressLookup.logger = Rails.logger
# or to silence logging unless there are errors for example:
#  EA::AddressLookup.logger.level = Logger::ERROR
#
module EA::AddressLookup
  class << self
    attr_writer :logger

    def logger
      @logger ||= Logger.new($stdout).tap do |log|
        log.progname = self.name
        log.level = Logger::DEBUG
      end
    end
  end
end
