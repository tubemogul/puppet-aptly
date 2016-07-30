require 'puppet'
require 'puppet/type/aptly_publish'

describe Puppet::Type.type(:aptly_publish) do

  before :each do
    @published = Puppet::Type.type(:aptly_publish).new(
      :name => 'weekly-update',
    )
  end

  describe 'validating parameters list' do
    [ :name, :force, :source_type ].each do |param|
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
    @published[:name] = 'foobar'
    expect(@published[:name]).to eq('foobar')
  end

  describe "force parameter" do
    [ :true, :false ].each do |value|
      it "should support #{value} as a value" do
        expect { described_class.new({
          :name  => 'weekly-update',
          :force => value,
        })}.to_not raise_error
      end

      it "should not accept a non-boolean" do
        expect { described_class.new({
          :name  => 'weekly-update',
          :force => 'foo',
        })}.to raise_error(Puppet::Error, /Invalid value/)
      end

      it "should have a non-nil default value" do
        expect(@published[:force]).not_to be_nil
      end

    end
  end

  describe 'source_type parameter' do
    it 'should not support value other than repo or snapshot' do
      expect{described_class.new({
        :name        => 'weekly-update',
        :source_type => 'foobar',
      })}.to raise_error(Puppet::Error, /Invalid value.*Valid values are repo, snapshot\./)
    end

    [ :repo, :snapshot ].each do |value|
      it "should accept #{value}" do
        @published[:source_type] = value
        expect(@published[:source_type]).to eq(value)
      end
    end

    it 'should default to a non-nil value' do
      expect(@published[:source_type]).not_to be_nil
    end
  end
end
