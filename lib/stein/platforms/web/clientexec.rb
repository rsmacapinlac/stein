
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

        def send_new_invoices

          browser = @_browser.b
          browser.goto "#{@_clientexec_url}/admin/index.php?fuse=billing&controller=invoice&view=invoices&filter=1"
          for tr in browser.div(id: 'invoicelist-grid').table.tbody.trs
            correct_row = false
            for td in tr.tds
              # is this the right column? and if it is, has the invoice been
              # sent?
              if td.attribute_value('dataindex') == 'billstatus'
                if td.text == 'not sent'
                  correct_row = true
                end
              end
            end

            # if the robot finds an invoice that has not been sent, then click
            # the checkbox
            if correct_row == true
              tr.td(class: 'checkbox').click
            end
          end

          send_invoice = browser.link(visible_text: 'Send Invoice')
          if send_invoice.present?
            send_invoice.click
          end

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
