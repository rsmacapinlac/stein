
class Stuff < Stein::Runner
  def exec
    @iwp = Stein::Platforms::Web::InfiniteWP.new('http://managewp.boogienet.com')
    @iwp.login('', '')
    @iwp.open_activity_log
    @iwp.browser.take_screenshot('test.png')
    @iwp.logout
    @iwp.close
  end
end

