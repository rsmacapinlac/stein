
module Stein
  module Platforms
    module Web
      class Wordpress

        attr_accessor :_browser
        attr_accessor :_wp_site
        attr_accessor :_wp_admin_login

        def initialize(wordpress_site, wordpress_admin_url=nil, browser=nil)
          @_wp_site = wordpress_site

          @_wp_admin_login = wordpress_admin_url
          @_wp_admin_login = "#{wordpress_site}/wp-admin" if @_wp_admin_login == nil

          @_browser = browser
          @_browser = Stein::Platforms::Web::Browser.new if @_browser == nil
        end

        def login(login, password)
          @_browser.b.goto @_wp_admin_login
          @_browser.b.text_field(id: 'user_login').set login
          @_browser.b.text_field(id: 'user_pass').set password
          @_browser.b.button(text: 'Log In').click
        end

        def logout
          @_browser.b.goto "#{@_wp_site}/wp-login.php?action=logout"
          @_browser.b.link(visible_text: 'log out').click
        end

        def change_theme(theme_name)
          @_browser.b.goto "#{@_wp_admin_login}/themes.php"
          active_theme = @_browser.b.div(class: ['theme', 'active']).h2.text.to_s
          if (active_theme != "Active: #{theme_name}")
            @_browser.b.link(aria_label: "Activate #{theme_name}").click
          end
        end

        def close
          @_browser.close
        end
      end
    end
  end
end
