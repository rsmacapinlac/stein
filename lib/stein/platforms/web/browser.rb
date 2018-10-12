require 'watir'
require 'webdrivers'

module Stein
  module Platforms
    module Web
      class Browser
        attr_accessor :b

        def initialize
          client = Selenium::WebDriver::Remote::Http::Default.new
          client.read_timeout = 600 # seconds – default is 60

          @b = Watir::Browser.new :firefox, http_client: client
        end

        def close
          @b.close
        end
      end
    end
  end
end
