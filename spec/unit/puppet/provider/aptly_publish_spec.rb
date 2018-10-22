require 'spec_helper'
require 'puppet/type/aptly_publish'

describe Puppet::Type.type(:aptly_publish).provider(:cli) do
  let(:resource) do
    Puppet::Type.type(:aptly_publish).new(
      name: 'test-snap',
      ensure: 'present',
      source_type: :snapshot,
      distribution: 'jessie-test-snap'
    )
  end

  let(:provider) do
    described_class.new(resource)
  end

  [:create, :destroy, :exists?].each do |method|
    it "have a(n) #{method}" do
      expect(provider).to respond_to(method)
    end
  end

  describe '#create' do
    it 'publish the snapshot' do
      Puppet_X::Aptly::Cli.expects(:execute).with(
        uid: '450',
        gid: '450',
        object: :publish,
        action: :snapshot,
        arguments: ['test-snap'],
        flags: { 'distribution' => 'jessie-test-snap', 'config' => '/etc/aptly.conf' }
      )
      provider.create
    end
  end

  describe '#destroy' do
    it 'drop the publication' do
      Puppet_X::Aptly::Cli.expects(:execute).with(
        uid: '450',
        gid: '450',
        object: :publish,
        action: 'drop',
        arguments: ['test-snap'],
        flags: { 'force-drop' => 'true', 'config' => '/etc/aptly.conf' }
      )
      provider.destroy
    end
  end

  describe '#exists?' do
    it 'check the publications list' do
      Puppet_X::Aptly::Cli.stubs(:execute).with(
        uid: '450',
        gid: '450',
        object: :publish,
        action: 'list',
        flags: { 'raw' => 'true', 'config' => '/etc/aptly.conf' },
        exceptions: false
      ).returns "foo\ntest-snap\nbar"
      expect(provider.exists?).to eq(true)
    end
    it 'handle empty publications' do
      Puppet_X::Aptly::Cli.stubs(:execute).with(
        uid: '450',
        gid: '450',
        object: :publish,
        action: 'list',
        flags: { 'raw' => 'true', 'config' => '/etc/aptly.conf' },
        exceptions: false
      ).returns ''
      expect(provider.exists?).to eq(false)
    end
  end
end
