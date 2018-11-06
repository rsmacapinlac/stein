
require 'singleton'
require 'stein/platforms/web/browser'
require 'stein/platforms/web/wordpress'
require 'stein/platforms/web/infinitewp'
require 'stein/platforms/web/clientexec'
require 'stein/runner'

module Stein
  class Application
    include Singleton

    def initialize(*)
      set_environment
      # maybe dynamically load libraries?
    end

    private

    def set_environment
      ENV["STEIN_ENV"] = 'development'
    end
  end
end
