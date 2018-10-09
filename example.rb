
class Stuff < Stein::Runner
  def exec
    @wp = Stein::Platforms::Web::Wordpress.new("http://wordpressexample.com")
    @wp.login('hello@something.com', 'dontputyourpasswordhere')
    @wp.change_theme 'Twenty Fifteen'
    @wp.close
  end
end

