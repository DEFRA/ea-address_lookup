# A consumer can hook into logging like so:
#   Whereabouts.logger = Rails.logger
# or to silence logging unless there are errors for example:
#  Whereabouts.logger.level = Logger::ERROR
#
module Whereabouts
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
