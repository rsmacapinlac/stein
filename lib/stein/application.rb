require 'stein/platforms/web/browser'
require 'stein/platforms/web/wordpress'
require 'stein/platforms/web/infinitewp'
require 'stein/platforms/web/clientexec'
require 'stein/runner'
require 'stein/logging'
require 'stein/config'

module Stein
  class Application
    attr_accessor :robot_file

    def initialize
      Stein::Config.instance
    end

    def run_robot
      load_robot
      eval("#{Stein::Runner.descendants.first}.instance.loader")
    end

    private

    def load_robot
      load @robot_file
    end
  end
end
