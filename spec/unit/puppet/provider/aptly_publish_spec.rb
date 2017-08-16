require 'spec_helper'
require 'puppet/type/aptly_publish'

describe Puppet::Type.type(:aptly_publish).provider(:cli) do
  let(:resource) do
    Puppet::Type.type(:aptly_publish).new(
      name: 'test-snap',
      ensure: 'present',
      source_type: :snapshot,
      distribution: 'jessie-test-snap',
      prefix: 'test-prefix',
      architectures: ['amd64,i386'],
      label: 'Debian-Security'
    )
  end

  let(:resource_with_all_architectures) do
    Puppet::Type.type(:aptly_publish).new(
      name: 'test-snap',
      ensure: 'present',
      source_type: :snapshot,
      distribution: 'jessie-test-snap',
      prefix: 'test-prefix'
    )
  end

  let(:provider) do
    described_class.new(resource)
  end

  let(:provider_with_all_architectures) do
    described_class.new(resource_with_all_architectures)
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
        arguments: ['test-snap', 'test-prefix'],
        flags: {
          'architectures' => 'amd64,i386',
          'distribution'  => 'jessie-test-snap',
          'label'         => 'Debian-Security'
        }
      )
      provider.create
    end

    it 'publish the snapshot (all architectures)' do
      Puppet_X::Aptly::Cli.expects(:execute).with(
        uid: '450',
        gid: '450',
        object: :publish,
        action: :snapshot,
        arguments: ['test-snap', 'test-prefix'],
        flags: {
          'distribution' => 'jessie-test-snap',
          'label'        => ''
        }
      )
      provider_with_all_architectures.create
    end
  end

  describe '#destroy' do
    it 'drop the publication' do
      Puppet_X::Aptly::Cli.expects(:execute).with(
        uid: '450',
        gid: '450',
        object: :publish,
        action: 'drop',
        arguments: ['test-snap', 'test-prefix'],
        flags: { 'force-drop' => 'true' }
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
        flags: { 'raw' => 'true' }
      ).returns ". foo\ntest-prefix test-snap\n. bar"
      expect(provider.exists?).to eq(true)
    end
    it 'handle empty publications' do
      Puppet_X::Aptly::Cli.stubs(:execute).with(
        uid: '450',
        gid: '450',
        object: :publish,
        action: 'list',
        flags: { 'raw' => 'true' }
      ).returns ''
      expect(provider.exists?).to eq(false)
    end
  end
end
