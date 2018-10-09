
module Stein
  module Platforms
    module Web
      class InfiniteWP

        attr_accessor :_browser
        attr_accessor :_infinitewp_url

        def initialize(infinitewp_url, browser=nil)
          @_infinitewp_url = infinitewp_url

          @_browser = browser
          @_browser = Stein::Platforms::Web::Browser.new if @_browser == nil
        end

        def login(login, password)
          @_browser.b.goto "#{@_infinitewp_url}/login.php"
          @_browser.b.text_field(name:'email').set login
          @_browser.b.text_field(name:'password').set password
          @_browser.b.button(text:'Log in').click
        end

        def logout
          @_browser.b.goto "#{@_infinitewp_url}/login.php?logout=now"
        end

        def update_all_sites
          browser = @_browser.b
          update_all = browser.link(visible_text: 'Update All Sites')
          if (update_all.exists?)
            update_all.click
            confirm = browser.link(visible_text: 'Yes! Go ahead.')
            if (confirm.exists?)
              sleep(10)
              confirm.click
              self.reload_data
            end
          end
        end

        def reload_data
          last_reload_time = @_browser.b.div(id: 'lastReloadTime').text.to_s
          sleep(30)
          @_browser.b.div(id: 'clearPluginCache').click
          @_browser.b.link(id: 'reloadStats').click
          @_browser.b.wait_until { |b|
            b.div(id: 'lastReloadTime').text.to_s != last_reload_time
          }
        end

        def close
          @_browser.b.close
        end

      end
    end
  end
end
