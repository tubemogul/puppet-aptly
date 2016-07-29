require 'puppet'
require 'puppet/type/aptly_snapshot'

describe Puppet::Type.type(:aptly_snapshot) do

  before :each do
    @snap = Puppet::Type.type(:aptly_snapshot).new(
      :name => '20160729-global-release',
    )
  end

  describe 'validating parameters list' do
    [ :name, :force, :source_type, :source_name, :description, :snapshots, :package_refs ].each do |param|
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
    @snap[:name] = 'foobar'
    expect(@snap[:name]).to eq('foobar')
  end

  describe "force parameter" do
    [ :true, :false ].each do |value|
      it "should support #{value} as a value" do
        expect { described_class.new({
          :name  => '20160729-global-release',
          :force => value,
        })}.to_not raise_error
      end

      it "should not accept a non-boolean" do
        expect { described_class.new({
          :name  => '20160729-global-release',
          :force => 'foo',
        })}.to raise_error(Puppet::Error, /Invalid value/)
      end

      it "should have a non-nil default value" do
        expect(@snap[:force]).not_to be_nil
      end

    end
  end

  describe 'source_type parameter' do
    it 'should not support value other than repo or snapshot' do
      expect{described_class.new({
        :name        => '20160729-global-release',
        :source_type => 'foobar',
      })}.to raise_error(Puppet::Error, /Invalid value.*Valid values are mirror, repository, snapshot, empty\./)
    end

    [ :mirror, :repository, :snapshot, :empty ].each do |value|
      it "should accept #{value}" do
        @snap[:source_type] = value
        expect(@snap[:source_type]).to eq(value)
      end
    end

    it 'should default to a non-nil value' do
      expect(@snap[:source_type]).not_to be_nil
    end
  end

  describe 'string parameters list' do
    [ :source_name, :description, :snapshots, :package_refs ].each do |param|
      it "should accept a #{param}" do
        @snap[param] = 'foobar'
        expect(@snap[param]).to eq('foobar')
      end
    end
  end
end
