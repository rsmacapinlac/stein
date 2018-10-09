require 'watir'
require 'webdrivers'

module Stein
  module Platforms
    module Web
      class Browser
        attr_accessor :b

        def initialize
          @b = Watir::Browser.new :firefox
        end

        def close
          @b.close
        end
      end
    end
  end
end
