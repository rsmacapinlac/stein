require 'logger'
require 'stein/config'

module Stein
  module Logging
    @@logger = nil

    def logger
      if @@logger.nil?
        @@logger = Logger.new(STDOUT)
        @@logger.level = Stein::Config.instance.log_level
      end

      return @@logger
    end
  end
end
