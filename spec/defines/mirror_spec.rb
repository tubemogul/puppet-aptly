require 'spec_helper'

describe 'aptly::mirror' do
  context 'basic mirror' do
    let(:title) { 'debian-main' }
    let(:params) do
      {
        uid: '450',
        gid: '450',
        location: 'http://ftp.us.debian.org/debian',
        distribution: 'jessie',
        architectures: %w(amd64 i386),
        components: %w(main contrib),
        with_sources: true,
        with_udebs: true
      }
    end

    it 'call the aptly_mirror provider' do
      should contain_aptly_mirror('debian-main').\
        with_ensure('present').\
        with_uid('450').\
        with_gid('450').\
        with_location('http://ftp.us.debian.org/debian').\
        with_distribution('jessie').\
        with_architectures(%w(amd64 i386)).\
        with_components(%w(main contrib)).\
        with_with_sources(true).\
        with_with_udebs(true)
    end
  end

  context 'location validation' do
    let(:title) { 'debian-main' }
    let(:params) do
      {
        uid: '450',
        gid: '450',
        location: 'my_bad_location',
        distribution: 'jessie',
        architectures: %w(amd64 i386),
        components: %w(main contrib),
        with_sources: true,
        with_udebs: true
      }
    end
    it { should raise_error(Puppet::Error, %r{does not match}) }
  end
end
