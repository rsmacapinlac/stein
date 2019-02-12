require 'selenium-webdriver'
require 'dotenv'
require 'stein/platforms/web/web_automator'

module Stein
  module Platforms
    module Web
      class Browser < WebAutomator
        attr_accessor :b, :wait

        def initialize()
          Dotenv.load

          @b = Selenium::WebDriver.for :firefox
          @wait = Selenium::WebDriver::Wait.new(timeout: 15)

          logger.debug "Initialized #{@b}, headless: #{@is_headless}"
        end

        def text_field(name)
          @b.find_element(name: name)
        end

        def get_element_by_id(id)
          @b.find_element(id: id)
        end

        def get_element_by_class(cl)
          @b.find_element(class: cl)
        end
        def get_element_by_text(contains)
          @b.find_element(xpath: "//*[contains(text(), '#{contains}')]")
        end

        def goto(url)
          @b.navigate.to url
        end

        def resize_to(w, h)
          @b.manage.window.resize_to(w, h)
        end

        def close
          @b.close
          logger.debug "#{@b} closed"
        end
      end
    end
  end
end
