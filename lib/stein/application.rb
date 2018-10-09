
require 'singleton'
require 'stein/platforms/web/browser'
require 'stein/platforms/web/wordpress'
require 'stein/platforms/web/infinitewp'
require 'stein/platforms/web/clientexec'
require 'stein/runner'

module Stein
  class Application
    include Singleton

    def initialize
      puts 'initializing'
    end
  end
end
