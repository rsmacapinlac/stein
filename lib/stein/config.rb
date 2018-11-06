require 'singleton'
require 'dotenv'

module Stein
  class Config
    include Singleton

    attr_accessor :log_level
    attr_accessor :log_filepath
    attr_accessor :environment
    attr_accessor :headless

    def initialize
      set_environment
      set_headless

      @log_level    = Logger::DEBUG

      log_dir      = File.join(Dir.pwd, 'logs')
      @log_filepath = File.join(log_dir, "#{@environment}.log")
    end

    def what_environment?
      return @environment
    end

    private

    def set_headless
      # set headless to come from environment
      @headless = !(@environment.eql?('development'))
      # Unless the RUN_HEADLESS environment variable is set
      @headless = (ENV['RUN_HEADLESS'] == 'false') unless ENV['RUN_HEADLESS'].nil?
    end

    def set_environment
      @environment = 'development'
      unless ENV['STEIN_ENV'].nil?
        unless (@environment.eql? ENV['STEIN_ENV'].downcase)
          @environment = ENV['STEIN_ENV']
        end
      end
    end

  end
end
