require 'singleton'
require 'dotenv'
require 'logger'

module Stein
  class Config
    include Singleton

    attr_accessor :log_level

    def initialize
      @log_level = Logger::DEBUG
    end

  end
end
