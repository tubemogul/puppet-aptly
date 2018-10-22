require 'spec_helper'
require 'puppet/type/aptly_repo'

describe Puppet::Type.type(:aptly_repo).provider(:cli) do
  let(:resource) do
    Puppet::Type.type(:aptly_repo).new(
      name: 'foo',
      ensure: 'present'
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
    it 'create the repo' do
      Puppet_X::Aptly::Cli.expects(:execute).with(
        uid: '450',
        gid: '450',
        object: :repo,
        action: 'create',
        arguments: ['foo'],
        flags: {
          'component'    => 'main',
          'distribution' => '',
          'config'       => '/etc/aptly.conf'
        }
      )
      provider.create
    end
  end

  describe '#destroy' do
    it 'drop the repo' do
      Puppet_X::Aptly::Cli.expects(:execute).with(
        uid: '450',
        gid: '450',
        object: :repo,
        action: 'drop',
        arguments: ['foo'],
        flags: { 'force' => 'true', 'config' => '/etc/aptly.conf' }
      )
      provider.destroy
    end
  end

  describe '#exists?' do
    it 'check the repo list' do
      Puppet_X::Aptly::Cli.stubs(:execute).with(
        uid: '450',
        gid: '450',
        object: :repo,
        action: 'list',
        flags: { 'raw' => 'true', 'config' => '/etc/aptly.conf' },
        exceptions: false
      ).returns "foo\ntest-snap\nbar"
      expect(provider.exists?).to eq(true)
    end
    it 'handle without repo' do
      Puppet_X::Aptly::Cli.stubs(:execute).with(
        uid: '450',
        gid: '450',
        object: :repo,
        action: 'list',
        flags: { 'raw' => 'true', 'config' => '/etc/aptly.conf' },
        exceptions: false
      ).returns ''
      expect(provider.exists?).to eq(false)
    end
  end
end
