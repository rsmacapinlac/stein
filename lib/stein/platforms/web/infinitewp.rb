
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

        def hide_sites_menu
          browser = @_browser.b
          browser.div(class: 'showFooterSelector').click
          sites_menu = browser.div(id: 'bottom_sites_cont')
          if sites_menu.present?
            browser.div(class: 'showFooterSelector').click
          end
        end

        def open_site_selector(main_menu_item, sub_menu_item)
          browser = @_browser.b
          self.hide_sites_menu
          browser.link(visible_text: main_menu_item).hover
          browser.link(visible_text: sub_menu_item).click

          browser.wait_until { |b|
            b.div(class: 'siteSelectorContainer').present?
          }
        end

        def remove_notifications
          browser = @_browser.b
          for notification in browser.divs(class: 'notification')
            notification.div(class: 'n_close').click
          end
        end

        def malware_scan(site)
          browser = @_browser.b
          self.open_site_selector('Protect', 'Malware Scan')

          browser.div(class: 'bywebsites').link(visible_text: site).click
          browser.link(id: 'scanSucuri').click
        end

        def wordfence_scan(site)
          browser = @_browser.b
          self.open_site_selector('Protect', 'Wordfence')

          browser.div(class: 'bywebsites').link(visible_text: site).click
          browser.link(id: 'scanWordfence').click
          self.monitor_activity_log
          self.remove_notifications
        end

        def select_site(site)
          browser = @_browser.b
          browser.div(id: 'bottom_sites_cont').link(visible_text: site).hover
        end

        def copy_live_to_stage(site)
          self.select_site(site)
          browser = @_browser.b
          browser.wait_until { |b|
            b.div(id: 'bottomToolbarOptions').present?
          }
          browser.link(visible_text: 'Copy live to staging').click
          browser.wait_until { |b|
            b.div(class: 'dialog_cont').present?
          }
          browser.link(id: 'confirm_staging').click

          self.monitor_activity_log
          self.remove_notifications

        end

        def monitor_activity_log_for(something)
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

        def open_backup
          browser = @_browser.b
          self.hide_sites_menu
          browser.link(visible_text: 'Protect').hover
          browser.link(visible_text: 'Backups').click
          browser.wait_until { |b|
            b.div(id: 'backupPageMainCont').present?
          }
        end

        def create_backup(site, backup_name)
          self.open_backup

          browser = @_browser.b
          browser.link(visible_text: 'Create New Backup').click
          browser.wait_until { |b|
            b.div(id: 'modalDiv').present?
          }

          browser.div(id: 'modalDiv').link(visible_text: site).click
          browser.div(id: 'enterBackupDetails').click
          browser.wait_until { |b|
            b.div(id: 'modalDiv').div(visible_text: 'CREATE A NEW BACKUP').present?
          }
          browser.text_field(id: 'backupName').set backup_name
          browser.link(visible_text: 'Phoenix (Beta)').click
          browser.link(visible_text: 'Backup Now').click
        end

        def download_backup(site, backup_name)
          self.open_backup

          browser = @_browser.b
          browser.text_field(class: ['input_type_filter', 'searchItems']).set site
          row = browser.div(id: 'backupList').
            div(class: 'row_name', visible_text: site)
          row.click

          row_detailed = row.parent.parent.div(text: "#{backup_name}")
          #puts row_detailed.parent.html
          row_detailed.parent.link(class: 'multiple_downloads').click

          browser.wait_until { |b|
            b.div(class: 'dialog_cont').
              div(visible_text: 'DOWNLOAD BACKUP PART FILES').present?
          }

          for link in browser.links(class: 'part_download')
            unless link.href.include? "tmp"
              link.click
            end
          end

          browser.send_keys :escape

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
