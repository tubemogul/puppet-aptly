require 'spec_helper'

describe Puppet_X::Aptly::Cli do
  include described_class
  describe '#execute (stubs)' do
    before :each do
      Process.stubs(:waitpid2).with(12_345).returns([12_345, stub('child_status', exitstatus: 0)])
      # Returning the command that should have been executed
      Puppet::Util::ExecutionStub.set do |command, _args, _stdin, _stdout, _stderr|
        command.strip
      end
    end

    describe 'object parameter' do
      [:mirror, :repo, :snapshot, :publish, :package, :db].each do |objname|
        it "should accept #{objname}" do
          expect(described_class.execute(
                   uid: '450',
                   gid: '450',
                   object: objname
          )).to eq("aptly  #{objname}")
        end
      end
    end

    describe 'action parameter' do
      it 'should accept it' do
        expect(described_class.execute(
                 uid: '450',
                 gid: '450',
                 object: :publish,
                 action: 'list'
        )).to eq('aptly  publish list')
      end
    end

    describe 'arguments parameter' do
      it 'should accept an array' do
        expect(described_class.execute(
                 uid: '450',
                 gid: '450',
                 object: :mirror,
                 action: 'create',
                 arguments: ['debian-main', 'http://ftp.us.debian.org']
        )).to eq('aptly  mirror create debian-main http://ftp.us.debian.org')
      end
    end

    describe 'flags parameter' do
      it 'should accept a Hash' do
        expect(described_class.execute(
                 uid: '450',
                 gid: '450',
                 object: :mirror,
                 action: 'create',
                 arguments: ['debian-main', 'http://ftp.us.debian.org'],
                 flags: { 'architectures' => 'amd64,i386', 'ignore-signatures' => 'false' }
        )).to eq('aptly -architectures=amd64,i386 -ignore-signatures=false mirror create debian-main http://ftp.us.debian.org')
      end
    end
  end
end
