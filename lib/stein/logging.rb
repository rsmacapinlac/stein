require 'logger'
require 'stein/config'

module Stein
  module Logging
    @@logger = nil

    def logger

      if @@logger.nil?
        log_file = File.new Stein::Config.instance.log_filepath, 'a'

        if Stein::Config.instance.what_environment?.eql?('development')
          @@logger = Logger.new MultiIO.new STDOUT, log_file
        else
          @@logger = Logger.new log_file
        end

        @@logger.level = Stein::Config.instance.log_level
      end

      return @@logger
    end

    private

    def log_file_by(environment)
    end

    class MultiIO
      def initialize(*targets)
        @targets = targets
      end

      def write(*args)
        @targets.each {|t| t.write(*args)}
      end

      def close
        @targets.each(&:close)
      end
    end

  end
end
