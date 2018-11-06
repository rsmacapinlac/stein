RSpec.describe Stein::Platforms::Web::InfiniteWP do
  context 'has_updates' do
    before :each do
      @managewp = Stein::Platforms::Web::InfiniteWP.new("http://managewp.boogienet.com")
      has_update_fixture = File.absolute_path File.join(Dir.pwd, 'spec', 'fixtures', 'infinitewp', 'has-updates.html')
      infinitewp_fixture = "file://#{has_update_fixture}"
      @managewp = Stein::Platforms::Web::InfiniteWP.new(infinitewp_fixture)
      @managewp.browser.goto infinitewp_fixture
    end

    it 'should know where there are updates to sites' do
      expect(@managewp.has_updates?).to eql(true)
    end

    it 'should know how many sites have updates' do
      expect(@managewp.which_sites_have_updates).not_to be_empty
    end
    after :each do
      @managewp.close
    end
  end
end
