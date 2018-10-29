require 'watir'
require 'webdrivers'
require 'dotenv'

module Stein
  module Platforms
    module Web
      class Browser
        attr_accessor :b

        def initialize(is_headless = true)
          Dotenv.load

          download_directory = "#{Dir.pwd}/Downloads"
          download_directory.tr!('/', '\\') if Selenium::WebDriver::Platform.windows?

          profile = Selenium::WebDriver::Firefox::Profile.new
          profile['browser.download.folderList'] = 2 # custom location
          profile['browser.download.dir'] = download_directory
          profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/tmp, application/zip, application/gzip, application/x-gzip, application/x-gunzip, application/gzipped, application/gzip-compressed, application/x-compressed, application/x-compress, gzip/document, application/octet-stream'

          client = Selenium::WebDriver::Remote::Http::Default.new
          client.read_timeout = 600 # seconds – default is 60

          @is_headless = is_headless
          @is_headless = (ENV['RUN_HEADLESS'].downcase == 'true') unless ENV['RUN_HEADLESS'].nil?
          # puts "is_headless: #{@is_headless}"

          @b = Watir::Browser.new :firefox,
            http_client: client,
            profile: profile,
            headless: @is_headless

        end
        def resize_to(w, h)
          @b.window.resize_to(w, h)
        end

        def close
          @b.close
        end
      end
    end
  end
end
