# frozen_string_literal: true

require 'stein/platforms/web/web_automator'

module Stein
  module Platforms
    module Web
      # Responsible for automating interactions with InfiniteWP
      class InfiniteWP < WebAutomator
        attr_accessor :_browser
        attr_accessor :_infinitewp_url

        def initialize(infinitewp_url)
          @_infinitewp_url = infinitewp_url

          @_browser = Stein::Platforms::Web::Browser.new if @_browser.nil?
          @_browser.resize_to(1024, 800)
          logger.debug "Init browser: #{@_browser}"
          logger.debug "Browser size: #{browser.b.manage.window.size}"
        end

        def browser
          @_browser
        end

        def login(login, password)
          infinite_url_login = "#{@_infinitewp_url}/login.php"
          browser.goto infinite_url_login
          logger.info "Opened InfiniteWP at #{infinite_url_login}"

          browser.text_field('email').send_keys login
          browser.text_field('password').send_keys password
          browser.get_element_by_id('loginSubmitBtn').click
          logger.info "Logged in with #{login}"
        end

        def logout
          browser.goto "#{@_infinitewp_url}/login.php?logout=now"
          logger.info 'Logged out'
        end

        # Ensure that the sites menu is hidden, if it is already hidden then it
        # doesnt do anything.
        def hide_sites_menu
          browser.get_element_by_class('showFooterSelector').click if browser.get_element_by_id('bottom_sites_cont').displayed?
        end

        # Use the main menu to navigate IWP
        def select_menu(main_menu_item, sub_menu_item)
          logger.info("Opening menu: #{main_menu_item} > #{sub_menu_item}")
          hide_sites_menu

          menu_items = browser.b.find_elements(css: 'ul.site_nav li a')
          mi_anchor = nil
          menu_items.each do |menu_item|
            if menu_item.text == main_menu_item
              mi_anchor = menu_item
              break
            end
          end

          browser.b.action.move_to(mi_anchor).perform
          sub_items = mi_anchor.find_element(xpath: './..')
                               .find_element(tag_name: 'ul')
                               .find_elements(tag_name: 'li')

          sub_items.each do |sub_item|
            if sub_item.find_element(tag_name: 'a').text == sub_menu_item
              sub_item.click
            end
          end

          sleep(1)
        end

        def create_new_backup
          button = browser.wait.until do
            browser.b.find_element(id: 'restrictToggleCreateBackup')
          end
          browser.b.action.move_to(button).click(button).perform
          logger.info 'Create new backup'
        end

        def select_site_in_modal(site)
          browser.wait.until do
            test = browser.b.find_elements(class: 'dialog_cont')
            if test.count.zero?
              browser.get_element_by_class('website_items_cont')
            else
              test.first
            end
          end.find_element(link_text: site).click
          logger.info "Site selected: #{site}"
        end

        def click_backup_details
          enter_details = browser.b.find_element(id: 'enterBackupDetails')
          browser.b.action.move_to(enter_details).click(enter_details).perform
          logger.info 'Click backup details'
        end

        def add_backup_details(backup_name, backup_type = 'Phoenix (Beta)')
          bu_name = browser.wait.until do
            browser.b.find_element(id: 'backupName')
          end
          bu_name.send_keys backup_name
          logger.info "Backup name: #{backup_name}"

          bu_type = browser.b.find_element(link_text: backup_type)
          browser.b.action.move_to(bu_type).click(bu_type).perform
          logger.info "Backup type: #{backup_type}"
        end

        def start_backup
          start_action('backupNow', 'Backup')
        end

        def start_wordfence_scan
          start_action('scanWordfence', 'Wordfence Scan')
        end

        def start_malware_scan
          start_action('scanSucuri', 'Malware Scan')
        end

        def close
          @_browser.b.close
          logger.debug 'Browser closed'
        end

        def open_activity_log
          hide_sites_menu

          logger.info 'Opening activity log'
          menu_item = browser.get_element_by_text('Activity Log')
          browser.b.action.move_to(menu_item).click(menu_item).perform
          sleep(2)
        end

        def monitor_activity_log

          open_activity_log

          running_items = 1
          until running_items.zero?
            logger.info "In progress items: #{running_items}"
            sleep(5)
            reload_btn = browser.b.find_element(class: 'refreshData')
            browser.b.action.move_to(reload_btn).click(reload_btn).perform
            running_items = browser
                            .b
                            .find_elements(css: 'div.in_progress.row_summary')
                            .count
          end
        end

        # Returns an array of sites that have identified updates
        def find_sites_with_updates
          updates = browser.b.find_elements(css: 'div#siteViewUpdateContent div.row_summary')
          sites = []
          updates.each do |update|
            sites << update.find_element(css: 'div.row_name').text
          end
          sites
        end

        private

        def start_action(id, name)
          startbtn = browser.b.find_element(id: id)
          browser.b.action.move_to(startbtn).click(startbtn).perform
          logger.info "Start action #{name} (id: #{id})"
        end
      end
    end
  end
end
