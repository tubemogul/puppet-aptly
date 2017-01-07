require 'puppet'
require 'puppet/type/aptly_repo'

describe Puppet::Type.type(:aptly_repo) do
  before :each do
    @repo = Puppet::Type.type(:aptly_repo).new(
      name: 'bar'
    )
  end

  describe 'validating parameters list' do
    [:name, :force, :default_component, :default_distribution].each do |param|
      it "should have a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end
  end

  describe 'namevar validation' do
    it 'should have :name as its namevar' do
      expect(described_class.key_attributes).to eq([:name])
    end
  end

  it 'should accept a name' do
    @repo[:name] = 'foobar'
    expect(@repo[:name]).to eq('foobar')
  end

  describe 'force parameter' do
    [:true, :false].each do |value|
      it "should support #{value} as a value" do
        expect do
          described_class.new(name: 'bar',
                              force: value)
        end.to_not raise_error
      end

      it 'should not accept a non-boolean' do
        expect do
          described_class.new(name: 'bar',
                              force: 'foo')
        end.to raise_error(Puppet::Error, /Invalid value/)
      end

      it 'should have a non-nil default value' do
        expect(@repo[:force]).not_to be_nil
      end
    end
  end

  describe 'default_distribution parameter' do
    it 'should not support non-string as a value' do
      expect do
        @repo[:default_distribution] = 1234
      end.to raise_error(Puppet::Error, /is not a valid distribution/)
      expect do
        @repo[:default_distribution] = %w(foo bar)
      end.to raise_error(Puppet::Error, /is not a valid distribution/)
    end
  end

  describe 'default_component parameter' do
    it 'should accept a string' do
      @repo[:default_component] = 'contrib'
      expect(@repo[:default_component]).to eq('contrib')
    end

    it 'should not support non-string as a value' do
      expect do
        @repo[:default_component] = 1234
      end.to raise_error(Puppet::Error, /is not a valid component/)
      expect do
        @repo[:default_component] = %w(foo bar)
      end.to raise_error(Puppet::Error, /is not a valid component/)
    end
  end
end
