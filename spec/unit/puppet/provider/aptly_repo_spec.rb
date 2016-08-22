require 'spec_helper'
require 'puppet/type/aptly_repo'

describe Puppet::Type.type(:aptly_repo).provider(:cli) do
  let(:resource) do
    Puppet::Type.type(:aptly_repo).new(
      :name         => 'foo',
      :ensure       => 'present',
    )
  end

  let(:provider) do
    described_class.new(resource)
  end

  [:create, :destroy, :exists? ].each do |method|
    it "should have a(n) #{method}" do
      expect(provider).to respond_to(method)
    end
  end

  describe '#create' do
    it 'should create the repo' do
      Puppet_X::Aptly::Cli.expects(:execute).with(
        object: :repo,
        action: 'create',
        arguments: [ 'foo' ],
        flags: {
        'component'    => 'main',
        'distribution' => '',
        }
      )
      provider.create
    end
  end

  describe '#destroy' do
    it 'should drop the repo' do
      Puppet_X::Aptly::Cli.expects(:execute).with(
        object: :repo,
        action: 'drop',
        arguments: ['foo'],
        flags: { 'force' => 'true' },
      )
      provider.destroy
    end
  end

  describe '#exists?' do
    it 'should check the repo list' do
      Puppet_X::Aptly::Cli.stubs(:execute).with(
        object: :repo,
        action: 'list',
        flags: { 'raw' => 'true' },
        exceptions: false,
      ).returns "foo\ntest-snap\nbar"
      expect(provider.exists?).to eq(true)
    end
    it 'should handle without repo' do
      Puppet_X::Aptly::Cli.stubs(:execute).with(
        object: :repo,
        action: 'list',
        flags: { 'raw' => 'true' },
        exceptions: false,
      ).returns ''
      expect(provider.exists?).to eq(false)
    end
  end

end
