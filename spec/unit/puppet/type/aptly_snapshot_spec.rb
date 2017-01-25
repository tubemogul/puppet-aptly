require 'puppet'
require 'puppet/type/aptly_snapshot'

describe Puppet::Type.type(:aptly_snapshot) do
  before do
    @snap = Puppet::Type.type(:aptly_snapshot).new(
      name: '20160729-global-release'
    )
  end

  describe 'validating parameters list' do
    [:name, :force, :source_type, :source_name, :description, :snapshots, :package_refs].each do |param|
      it "has a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end
  end

  describe 'namevar validation' do
    it 'have :name as its namevar' do
      expect(described_class.key_attributes).to eq([:name])
    end
  end

  it 'accept a name' do
    @snap[:name] = 'foobar'
    expect(@snap[:name]).to eq('foobar')
  end

  describe 'force parameter' do
    [:true, :false].each do |value|
      it "support #{value} as a value" do
        expect do
          described_class.new(name: '20160729-global-release',
                              force: value)
        end.not_to raise_error
      end

      it 'do not accept a non-boolean' do
        expect do
          described_class.new(name: '20160729-global-release',
                              force: 'foo')
        end.to raise_error(Puppet::Error, /Invalid value/)
      end

      it 'have a non-nil default value' do
        expect(@snap[:force]).not_to be_nil
      end
    end
  end

  describe 'source_type parameter' do
    it 'do not support value other than predefined values' do
      expect do
        described_class.new(name: '20160729-global-release',
                            source_type: 'foobar')
      end.to raise_error(Puppet::Error, /Invalid value.*Valid values are mirror, repository, empty\./)
    end

    [:mirror, :repository, :empty].each do |value|
      it "accept #{value}" do
        @snap[:source_type] = value
        expect(@snap[:source_type]).to eq(value)
      end
    end

    it 'default to a non-nil value' do
      expect(@snap[:source_type]).not_to be_nil
    end
  end

  describe 'string parameters list' do
    [:source_name, :description, :snapshots, :package_refs].each do |param|
      it "accept a #{param}" do
        @snap[param] = 'foobar'
        expect(@snap[param]).to eq('foobar')
      end
    end
  end
end
