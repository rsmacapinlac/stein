require 'selenium-webdriver'
require 'dotenv'
require 'headless'
require 'stein/platforms/web/web_automator'

module Stein
  module Platforms
    module Web
      # Abstraction of the Selenium bindings
      #
      class Browser < WebAutomator
        attr_accessor :b, :wait

        def initialize
          Dotenv.load
          # default to running headless
          @is_headless = ENV['IS_HEADLESS'] == 'true'
          @is_headless = true if ENV['IS_HEADLESS'].nil?

          if @is_headless == true
            @headless = Headless.new
            @headless.start
          end

          args = []

          @_browser_setting = ENV['BROWSER']
          @_browser_setting = 'chrome' if ENV['BROWSER'].nil?
          @_browser_setting = @_browser_setting.downcase
          if @_browser_setting.eql? 'chrome'
            @b = Selenium::WebDriver.for :chrome
          end
          if @_browser_setting.eql? 'firefox'
            options = Selenium::WebDriver::Firefox::Options.new(args: args)
            @b = Selenium::WebDriver.for :firefox, options: options
          end

          @wait = Selenium::WebDriver::Wait.new(timeout: 15)

          logger.debug "Initialized #{@b}, headless: #{@is_headless}"
        end

        def take_screenshot(img_file)
          @b.save_screenshot(img_file)
        end

        def text_field(name)
          @b.find_element(name: name)
        end

        def get_element_by_id(id)
          @b.find_element(id: id)
        end

        def get_element_by_class(cls)
          @b.find_element(class: cls)
        end

        def get_element_by_text(contains)
          @b.find_element(xpath: "//*[contains(text(), '#{contains}')]")
        end

        def goto(url)
          @b.navigate.to url
        end

        def resize_to(width, height)
          @b.manage.window.resize_to(width, height)
        end

        def close
          @b.close
          @headless.destroy
          logger.debug "#{@b} closed"
        end
      end
    end
  end
end
