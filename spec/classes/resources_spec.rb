require 'spec_helper'

describe 'aptly', type: :class do
  [%w(Debian ubuntu trusty), %w(Debian debian jessie)].each do |osfamily, lsbdistid, lsbdistcodename|
    let(:facts) do
      {
        osfamily: osfamily,
        lsbdistid: lsbdistid,
        lsbdistcodename: lsbdistcodename,
        architecture: 'amd64',
        puppetversion: Puppet.version
      }
    end

    context 'resource creation' do
      describe "create mirrors on #{osfamily}" do
        let :params do
          {
            'mirrors' => {
              'debian_stable' => {
                'location'      => 'http://ftp.us.debian.org/debian/',
                'distribution'  => 'stable',
                'components'    => ['main'],
                'architectures' => ['amd64']
              }
            }
          }
        end

        it { is_expected.to contain_class('aptly::resources') }
        it { is_expected.to contain_aptly__mirror('debian_stable').with_ensure('present') }
      end

      describe "create repos on #{osfamily}" do
        let :params do
          {
            'repos' => {
              'tubemogul_apps' => {
                'default_component' => 'stable'
              }
            }
          }
        end

        it { is_expected.to contain_class('aptly::resources') }
        it { is_expected.to contain_aptly__repo('tubemogul_apps').with_ensure('present').with_default_component('stable') }
      end
    end
  end
end