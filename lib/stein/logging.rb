require 'logger'
require 'stein/config'

module Stein
  module Logging
    @@logger = nil
    @@config = Stein::Config.instance

    def logger

      if @@logger.nil?
        Dir.mkdir @@config.log_dir unless Dir.exists? @@config.log_dir
        log_file = File.new @@config.log_filepath, 'a'


        if @@config.environment.eql?('development')
          @@logger = Logger.new MultiIO.new STDOUT, log_file
        else
          @@logger = Logger.new log_file
        end

        @@logger.level = @@config.log_level
      end

      return @@logger
    end

    private

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
