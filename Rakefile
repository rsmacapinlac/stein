require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'dotenv'
require 'stein'

RSpec::Core::RakeTask.new(:spec) do |t|
  ENV['STEIN_ENV'] = 'test'
end


# task :default => :spec

namespace :test do
  namespace :extract_fixtures do
    desc 'Extract fixtures from InfiniteWP'
    task :InfiniteWP, [:ElementId, :WaitForElementId, :FilePath] do |task, args|
      Dotenv.load

      html_path = Pathname.new args.FilePath
      @managewp = Stein::Platforms::Web::InfiniteWP.new("http://managewp.boogienet.com")
      @managewp.login ENV['INFINITE_EMAIL'], ENV['INFINITE_PASSWORD']
      @managewp.browser.goto 'http://managewp.boogienet.com'
      @managewp.browser.div(id: args.WaitForElementId).wait_until_present unless args.WaitForElementId.nil?
      html_template = "<html><body>\n\n#{@managewp.browser.div(id: args.ElementId).html}\n\n</body></html>"
      @managewp.logout
      @managewp.close

      File.write(html_path, html_template)

    end

    task :InfiniteWP_has_updates do
      Rake::Task['test:extract_fixtures:InfiniteWP'].invoke('pageContent', 'mainUpdateCont', 'spec/fixtures/infinitewp/has-updates.html')
    end
  end
end
