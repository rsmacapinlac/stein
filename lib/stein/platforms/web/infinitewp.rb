require 'stein/platforms/web/web_automator'

module Stein
  module Platforms
    module Web
      class InfiniteWP < WebAutomator

        attr_accessor :_browser
        attr_accessor :_infinitewp_url

        def initialize(infinitewp_url, browser=nil)
          # set time out for 10m
          Watir.default_timeout = 1200
          @_infinitewp_url = infinitewp_url

          @_browser = browser
          @_browser = Stein::Platforms::Web::Browser.new if @_browser == nil
          logger.debug "Initialized browser #{@_browser}"
        end

        def login(login, password)
          infinite_url_login = "#{@_infinitewp_url}/login.php"
          @_browser.b.goto infinite_url_login
          logger.info "Opened InfiniteWP at #{infinite_url_login}"
          @_browser.b.text_field(name:'email').set login
          @_browser.b.text_field(name:'password').set password
          @_browser.b.button(text:'Log in').click
          logger.info "Logged in with #{login}"
        end

        def logout
          @_browser.b.goto "#{@_infinitewp_url}/login.php?logout=now"
          logger.info "Logged out"
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
          sites_menu_found = sites_menu.present?
          logger.debug "Sites menu was found? #{sites_menu_found}"
          if sites_menu_found == true
            browser.div(class: 'showFooterSelector').click
            logger.info "Sites menu was clicked to hide"
          end
        end

        def open_site_selector(main_menu_item, sub_menu_item,
                               confirm_element = { class: 'siteSelectorContainer' })
          browser = @_browser.b
          self.hide_sites_menu
          browser.link(visible_text: main_menu_item).hover
          browser.link(visible_text: sub_menu_item).click
          browser.div(confirm_element).wait_until_present
          logger.debug "#{confirm_element} found"
        end

        def remove_notifications
          browser = @_browser.b
          for notification in browser.divs(class: 'notification')
            notification.div(class: 'n_close').click
            logger.debug "Removed notification #{notification}"
          end
        end

        def malware_scan(site)
          browser = @_browser.b
          self.open_site_selector('Protect', 'Malware Scan')

          browser.div(class: 'bywebsites').link(visible_text: site).click
          browser.link(id: 'scanSucuri').click
          logger.info "Start malware (sucuri) scan (#{site})"

          self.monitor_activity_log
        end

        def wordfence_scan(site)
          browser = @_browser.b
          self.open_site_selector('Protect', 'Wordfence')

          browser.div(class: 'bywebsites').link(visible_text: site).click
          browser.link(id: 'scanWordfence').click
          logger.info "Start wordfence scan (#{site})"

          self.monitor_activity_log
          self.remove_notifications
        end

        def has_updates?
          browser = @_browser.b
          browser.div(id: 'siteViewUpdateContent').
            div(class: 'rows_cont').present?
        end

        def which_sites_have_updates
          browser = @_browser.b
          sites = []
          browser.goto @_infinitewp_url
          updates_required = browser.div(id: 'siteViewUpdateContent').
            divs(class: 'rows_cont').count > 0
          logger.debug "There are site updates required: #{updates_required}"
          #logger.debug "Do sites require updates? #{is_empty}"
          if updates_required == true
            for row in browser.div(id: 'siteViewUpdateContent').
              div(class: 'rows_cont').divs(class: 'ind_row_cont')

              site = row.div(class: 'row_name').text
              sites << site
              logger.info "Added #{site} to list of sites that require updates"
            end
          end

          return sites
        end

        def select_site(site)
          browser = @_browser.b
          browser.div(id: 'bottom_sites_cont').link(visible_text: site).hover
        end

        def update_all_by_site(site)
          browser = @_browser.b
          browser.goto @_infinitewp_url
          site = browser.div(id: 'siteViewUpdateContent').
                    div(class: 'row_name',
                    visible_text: site)
          if site.present?
            row = site.parent
            row.link(class: 'update_all_group').click
            browser.div(class: 'dialog_cont').wait_until_present
            browser.link(visible_text: 'Yes! Go ahead.').click
            logger.info "Started Update All (#{site})"
            self.monitor_activity_log
          end
        end

        def update_all_in_staging(site)
          browser = @_browser.b
          browser.goto @_infinitewp_url
          row = browser.div(id: 'siteViewUpdateContent').
            div(class: 'row_name',
                visible_text: site).parent
          logger.debug "Found update row (#{site})"

          row.link(visible_text: 'Update All in Staging').click
          browser.div(class: 'dialog_cont').wait_until_present
          browser.link(id: 'groupUpdateInNewStage').click
          logger.info "Update all in staging for #{site}"

          self.monitor_activity_log
          self.remove_notifications
        end

        def monitor_activity_log
          logger.debug "Monitoring activity log"
          browser = @_browser.b
          browser.link(visible_text: 'Activity Log').click

          browser.div(class: 'history').wait_until_present

          keep_checking = true
          while keep_checking == true do
            browser.span(class: 'refreshData').click
            in_progress_divs = browser.div(id: 'historyPageContent').
              divs(class: 'in_progress')
            in_progress_divs.count
            keep_checking = in_progress_divs.count != 0
            logger.debug "Will continue to check? #{keep_checking}  #{in_progress_divs.count}"
            logger.info "Log items in progress #{in_progress_divs.count}"
            sleep(10)
          end
          logger.info "Activities in activity log are all completed"
        end

        def create_backup(site, backup_name, backup_type = 'Phoenix (Beta)')
          self.open_site_selector('Protect', 'Backups', {id: 'backupPageMainCont'})

          browser = @_browser.b
          browser.link(visible_text: 'Create New Backup').click
          browser.div(id: 'modalDiv').wait_until_present
          logger.debug 'Backup modal window open'

          browser.div(id: 'modalDiv').link(visible_text: site).click
          browser.div(id: 'enterBackupDetails').click
          logger.info "Select #{site} for backup"

          browser.div(id: 'modalDiv').
            div(visible_text: 'CREATE A NEW BACKUP').
            wait_until_present
          logger.debug 'Backup details modal window open'

          browser.text_field(id: 'backupName').set backup_name
          browser.link(visible_text: backup_type).click
          browser.link(visible_text: 'Backup Now').click
          logger.info "Backup Now #{backup_name} (#{backup_type})"
        end

        def download_backup(site, backup_name)
          self.open_backup

          browser = @_browser.b
          browser.text_field(class: ['input_type_filter', 'searchItems']).set site
          row = browser.div(id: 'backupList').
            div(class: 'row_name', visible_text: site)
          row.click

          row_detailed = row.parent.parent.div(text: "#{backup_name}")
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

        def close
          @_browser.b.close
          logger.debug 'Browser closed'
        end

      end
    end
  end
end
