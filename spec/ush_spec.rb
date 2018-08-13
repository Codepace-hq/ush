RSpec.describe Ush do
  it 'has a version number' do
    expect(Ush::VERSION).not_to be nil
  end

  it 'creates a database' do
    Ush::Sqlite.new
    expect(File.exist?(File.expand_path(File.join(File.dirname(__FILE__), '../db/ush.sqlite.db')))).to eql(true)
  end

  describe Ush::Adapter do
    describe 'shorten' do
      context 'given https://google.com' do
        it 'equals R6CTjQ' do
          expect(Ush::Adapter.shorten('https://google.com')).to eql('R6CTjQ')
        end
      end
    end
  end
end
