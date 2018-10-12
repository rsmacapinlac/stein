
module Stein
  module Platforms
    module Web
      class InfiniteWP

        attr_accessor :_browser
        attr_accessor :_infinitewp_url

        def initialize(infinitewp_url, browser=nil)
          # set time out for 10m
          Watir.default_timeout = 1200
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

        def has_updates?
          browser = @_browser.b
          update_all = browser.link(visible_text: 'Update All Sites')
          return update_all.exists?
        end

        def monitor_activity_log
          browser = @_browser.b
          browser.link(visible_text: 'Activity Log').click

          browser.wait_until { |b|
            b.div(class: 'history').present?
          }

          keep_checking = true
          while keep_checking == true do
            sleep(10)
            browser.span(class: 'refreshData').click
            keep_checking = browser.div(class: 'ind_row_cont').
              div(class: 'in_progress').
              exists?
          end
        end

        def create_backup(site, backup_name)
          browser = @_browser.b
          site = browser.link(visible_text: site)
          site.hover
          backup_now = browser.link(visible_text: 'Backup Now')
          backup_now.click

          backup_dialog = browser.div(class_name: ['dialog_cont', 'create_backup'])
          if backup_dialog.present?
            browser.text_field(id: 'backupName').set backup_name
            browser.link(visible_text: 'Backup Now').click

            self.monitor_activity_log
          end
        end

        def copy_live_to_staging(site)
          browser = @_browser.b
          site = browser.link(visible_text: site)
          site.hover
          copy_live_to_staging = browser.link(visible_text: 'Copy live to staging')
          copy_live_to_staging.click
          are_you_sure = browser.link(visible_text: 'Copy')
          if are_you_sure.present?
            are_you_sure.click

            self.monitor_activity_log
          end
        end

        def update_all_sites
          browser = @_browser.b
          update_all = browser.link(visible_text: 'Update All Sites')
          if (self.has_updates?)
            update_all.click
            confirm = browser.link(visible_text: 'Yes! Go ahead.')
            if (confirm.exists?)
              confirm.click
              self.reload_data
            end
          end
        end

        def reload_data
          # wait until the btn_reload is visible again
          # last_reload_time = @_browser.b.div(id: 'lastReloadTime').text.to_s
          @_browser.b.div(id: 'clearPluginCache').click
          @_browser.b.link(id: 'reloadStats').click
          sleep(10)
          @_browser.b.wait_until { |b|
            b.div(class: 'btn_reload').present?
          }
        end

        def close
          @_browser.b.close
        end

      end
    end
  end
end
