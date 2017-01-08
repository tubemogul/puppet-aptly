require 'spec_helper'
require 'puppet/type/aptly_publish'

describe Puppet::Type.type(:aptly_publish).provider(:cli) do
  let(:resource) do
    Puppet::Type.type(:aptly_publish).new(
      name: 'test-snap',
      ensure: 'present',
      source_type: :snapshot
    )
  end

  let(:provider) do
    described_class.new(resource)
  end

  [:create, :destroy, :exists?].each do |method|
    it "should have a(n) #{method}" do
      expect(provider).to respond_to(method)
    end
  end

  describe '#create' do
    it 'should publish the snapshot' do
      Puppet_X::Aptly::Cli.expects(:execute).with(
        object: :publish,
        action: :snapshot,
        arguments: ['test-snap']
      )
      provider.create
    end
  end

  describe '#destroy' do
    it 'should drop the publication' do
      Puppet_X::Aptly::Cli.expects(:execute).with(
        object: :publish,
        action: 'drop',
        arguments: ['test-snap'],
        flags: { 'force-drop' => 'true' }
      )
      provider.destroy
    end
  end

  describe '#exists?' do
    it 'should check the publications list' do
      Puppet_X::Aptly::Cli.stubs(:execute).with(
        object: :publish,
        action: 'list',
        flags: { 'raw' => 'true' },
        exceptions: false
      ).returns "foo\ntest-snap\nbar"
      expect(provider.exists?).to eq(true)
    end
    it 'should handle empty publications' do
      Puppet_X::Aptly::Cli.stubs(:execute).with(
        object: :publish,
        action: 'list',
        flags: { 'raw' => 'true' },
        exceptions: false
      ).returns ''
      expect(provider.exists?).to eq(false)
    end
  end
end
