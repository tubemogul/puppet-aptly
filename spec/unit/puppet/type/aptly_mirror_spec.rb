require 'puppet'
require 'puppet/type/aptly_mirror'

describe Puppet::Type.type(:aptly_mirror) do
  let(:mirror) do
    Puppet::Type.type(:aptly_mirror).new(
      name: 'trusty-main',
      location: 'http://us.archive.ubuntu.com/ubuntu/',
      distribution: 'trusty'
    )
  end

  describe 'validating parameters list' do
    [:name, :force, :update, :location, :distribution,
     :components, :architectures, :with_sources, :with_udebs].each do |param|
      it "have a #{param} parameter" do
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
    mirror[:name] = 'foobar'
    expect(mirror[:name]).to eq('foobar')
  end

  [:force, :with_sources, :with_udebs, :update].each do |param|
    describe "#{param} parameter" do
      [:true, :false].each do |value|
        it "support #{value} as a value" do
          expect do
            described_class.new(:name => 'trusty-main',
                                :location     => 'http://us.archive.ubuntu.com/ubuntu/',
                                :distribution => 'trusty',
                                param         => value)
          end.not_to raise_error
        end

        it 'do not accept a non-boolean' do
          expect do
            described_class.new(:name => 'trusty-main',
                                :location     => 'http://us.archive.ubuntu.com/ubuntu/',
                                :distribution => 'trusty',
                                param         => 'foo')
          end.to raise_error(Puppet::Error, %r{Invalid value})
        end

        it 'have a non-nil default value' do
          expect(mirror[param]).not_to be_nil
        end
      end
    end
  end

  describe 'location parameter' do
    it 'do not support numbers as a value' do
      expect do
        mirror[:location] = 1234
      end.to raise_error(Puppet::Error, %r{is not a valid location})
    end
    it 'do not support arrays as a value' do
      expect do
        mirror[:location] = %w(foo bar)
      end.to raise_error(Puppet::Error, %r{is not a valid location})
    end

    it 'require it' do
      expect do
        Puppet::Type.type(:aptly_mirror).new(name: 'trusty-main',
                                             distribution: 'trusty')
      end.to raise_error(Puppet::Error, %r{is not a valid location})
    end
  end

  describe 'distribution parameter' do
    it 'do not support numbers as a value' do
      expect do
        mirror[:distribution] = 1234
      end.to raise_error(Puppet::Error, %r{is not a valid distribution})
    end
    it 'do not support arrays as a value' do
      expect do
        mirror[:distribution] = %w(foo bar)
      end.to raise_error(Puppet::Error, %r{is not a valid distribution})
    end

    it 'require it' do
      expect do
        described_class.new(name: 'trusty-main',
                            location: 'http://us.archive.ubuntu.com/ubuntu/')
      end.to raise_error(Puppet::Error, %r{is not a valid distribution})
    end
  end

  describe 'components parameter' do
    it 'accept a string' do
      mirror[:components] = 'main'
      expect(mirror[:components]).to eq('main')
    end

    it 'accept a full array' do
      mirror[:components] = %w(main contrib)
      expect(mirror[:components]).to eq(%w(main contrib))
    end
  end

  describe 'architectures parameter' do
    it 'accept a string' do
      mirror[:architectures] = 'amd64'
      expect(mirror[:architectures]).to eq('amd64')
    end

    it 'accept a full array' do
      mirror[:architectures] = %w(i386 amd64 powerpc)
      expect(mirror[:architectures]).to eq(%w(i386 amd64 powerpc))
    end
  end
end
