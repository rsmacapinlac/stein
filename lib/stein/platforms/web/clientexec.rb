
module Stein
  module Platforms
    module Web
      class ClientExec

        attr_accessor :_browser
        attr_accessor :_clientexec_url

        def initialize(clientexec_url, browser=nil)
          @_clientexec_url = clientexec_url

          @_browser = browser
          @_browser = Stein::Platforms::Web::Browser.new if @_browser == nil
        end

        def login(login, password)
          @_browser.b.goto "#{@_clientexec_url}/index.php?fuse=home&view=login"
          @_browser.b.text_field(name:'email').set login
          @_browser.b.text_field(name:'passed_password').set password
          @_browser.b.button(text:'Sign In').click
        end
        def logout
          @_browser.b.link(class: 'user-avatar-link').click
          @_browser.b.link(visible_text: 'Logout').click
        end
        def close
          @_browser.b.close
        end
      end
    end
  end
end
