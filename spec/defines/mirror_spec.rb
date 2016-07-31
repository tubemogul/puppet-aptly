require 'spec_helper'

describe 'aptly::mirror' do
  context 'basic mirror' do
    let(:title) { 'debian-main' }
    let(:params) {{
      :location      => 'http://ftp.us.debian.org/debian',
      :distribution  => 'jessie',
      :architectures => [ 'amd64', 'i386' ],
      :components    => [ 'main', 'contrib' ],
      :with_sources  => true,
      :with_udebs    => true,
    }}

    it 'should call the aptly_mirror provider' do
      should contain_aptly_mirror('debian-main')\
        .with_ensure('present')\
        .with_location('http://ftp.us.debian.org/debian')\
        .with_distribution('jessie')\
        .with_architectures([ 'amd64', 'i386' ])\
        .with_components([ 'main', 'contrib' ])\
        .with_with_sources(true)\
        .with_with_udebs(true)
    end
  end

  context 'location validation' do
    let(:title) { 'debian-main' }
    let(:params) {{
      :location      => 'my_bad_location',
      :distribution  => 'jessie',
      :architectures => [ 'amd64', 'i386' ],
      :components    => [ 'main', 'contrib' ],
      :with_sources  => true,
      :with_udebs    => true,
    }}
    it { should raise_error(Puppet::Error, /does not match/) }
  end
end
