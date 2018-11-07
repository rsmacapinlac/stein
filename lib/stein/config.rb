require 'singleton'
require 'dotenv'
require 'stein/logging'

module Stein
  class Config
    include Singleton

    attr_accessor :log_level
    attr_accessor :log_dir
    attr_accessor :log_filepath
    attr_accessor :environment
    attr_accessor :headless

    def initialize
      Dotenv.load

      set_environment
      set_headless
      set_loglevel

      @log_dir      = File.join(Dir.pwd, 'logs')
      @log_filepath = File.join(log_dir, "#{@environment}.log")
    end

    private

    def set_loglevel
      if @environment.eql?('production')
        @log_level = Logger::INFO
      else
        @log_level    = Logger::DEBUG
      end
    end

    def set_headless
      # set headless to come from environment
      @headless = !(@environment.eql?('development'))
      # Unless the RUN_HEADLESS environment variable is set
      @headless = (ENV['RUN_HEADLESS'] == 'false') unless ENV['RUN_HEADLESS'].nil?
      ENV['RUN_HEADLESS'] = @headless.to_s
    end

    def set_environment
      @environment = 'development'
      unless ENV['STEIN_ENV'].nil?
        unless (@environment.eql? ENV['STEIN_ENV'].downcase)
          @environment = ENV['STEIN_ENV']
        end
      end
      ENV['STEIN_ENV'] = @environment
    end

  end
end
