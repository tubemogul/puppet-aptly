require 'puppet'
require 'puppet/type/aptly_mirror'

describe Puppet::Type.type(:aptly_mirror) do

  before :each do
    @mirror = Puppet::Type.type(:aptly_mirror).new(
      :name         => 'trusty-main',
      :location     => 'http://us.archive.ubuntu.com/ubuntu/',
      :distribution => 'trusty',
    )
  end

  describe 'validating parameters list' do
    [ :name, :force, :update, :location, :distribution,
      :components, :architectures, :with_sources, :with_udebs
    ].each do |param|
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
    @mirror[:name] = 'foobar'
    expect(@mirror[:name]).to eq('foobar')
  end

  [ :force, :with_sources, :with_udebs, :update ].each do |param|
    describe "#{param} parameter" do
      [ :true, :false ].each do |value|
        it "should support #{value} as a value" do
          expect { described_class.new({
            :name         => 'trusty-main',
            :location     => 'http://us.archive.ubuntu.com/ubuntu/',
            :distribution => 'trusty',
            param         => value,
          })}.to_not raise_error
        end

        it "should not accept a non-boolean" do
          expect { described_class.new({
            :name         => 'trusty-main',
            :location     => 'http://us.archive.ubuntu.com/ubuntu/',
            :distribution => 'trusty',
            param         => 'foo',
          })}.to raise_error(Puppet::Error, /Invalid value/)
        end

        it "should have a non-nil default value" do
          expect(@mirror[param]).not_to be_nil
        end

      end
    end
  end

  describe 'location parameter' do
    it 'should not support non-string as a value' do
      expect{
        @mirror[:location] = 1234
      }.to raise_error(Puppet::Error, /is not a valid location/)
      expect{
        @mirror[:location] = [ 'foo', 'bar' ]
      }.to raise_error(Puppet::Error, /is not a valid location/)
    end

    it 'should require it' do
      expect { Puppet::Type.type(:aptly_mirror).new({
        :name         => 'trusty-main',
        :distribution => 'trusty',
      })}.to raise_error(Puppet::Error, /is not a valid location/)
    end
  end

  describe 'distribution parameter' do
    it 'should not support non-string as a value' do
      expect{
        @mirror[:distribution] = 1234
      }.to raise_error(Puppet::Error, /is not a valid distribution/)
      expect{
        @mirror[:distribution] = [ 'foo', 'bar' ]
      }.to raise_error(Puppet::Error, /is not a valid distribution/)
    end

    it 'should require it' do
      expect { described_class.new({
        :name         => 'trusty-main',
        :location     => 'http://us.archive.ubuntu.com/ubuntu/',
      })}.to raise_error(Puppet::Error, /is not a valid distribution/)
    end
  end

  describe 'components parameter' do
    it 'should accept a string' do
      @mirror[:components] = 'main'
      expect(@mirror[:components]).to eq('main')
    end

    it 'should accept a full array' do
      @mirror[:components] = [ 'main', 'contrib' ]
      expect(@mirror[:components]).to eq([ 'main', 'contrib' ])
    end
  end

  describe 'architectures parameter' do
    it 'should accept a string' do
      @mirror[:architectures] = 'amd64'
      expect(@mirror[:architectures]).to eq('amd64')
    end

    it 'should accept a full array' do
      @mirror[:architectures] = [ 'i386', 'amd64', 'powerpc' ]
      expect(@mirror[:architectures]).to eq([ 'i386', 'amd64', 'powerpc' ])
    end
  end

end
