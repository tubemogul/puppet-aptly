require 'spec_helper'

describe 'aptly', type: :class do
  on_supported_os.each do |os, os_facts|
    let(:facts) do
      os_facts
    end

    context 'default installation with installation repo on supported os' do
      describe "aptly class without any parameters on #{os}" do
        let(:params) { {} }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('aptly') }
        it { is_expected.to contain_class('aptly::params') }
        it { is_expected.to contain_class('aptly::install').that_comes_before('Class[aptly::config]') }
        it { is_expected.to contain_class('aptly::config') }
        it { is_expected.to contain_class('aptly::service').that_subscribes_to('Class[aptly::config]') }
        it { is_expected.to contain_service('aptly') }
        it { is_expected.to contain_package('aptly').with_ensure('installed') }
      end
    end

    context 'default params on supported os - testing child classes' do
      describe "aptly class with all default parameters on #{os}" do
        let(:params) { {} }

        ###
        # aptly::installed
        ###
        it { is_expected.to contain_package('aptly').with_ensure('installed').with_provider('apt') }
        it { is_expected.to contain_class('apt') }
        it { is_expected.to contain_class('apt::params') }

        it do
          is_expected.to contain_apt__source('aptly').\
            with_location('http://repo.aptly.info').\
            with_release('squeeze').\
            with_repos('main').\
            with_key('id' => 'DF32BC15E2145B3FA151AED19E3E53F19C7DE460', 'server' => 'keys.gnupg.net').\
            with_include('src' => false, 'deb' => true).\
            that_notifies('Class[apt::update]')

          is_expected.to contain_class('apt::update').that_comes_before('Package[aptly]')
        end

        it do
          is_expected.to create_file('/etc/init.d/aptly').\
            with_mode('0755').\
            with_owner('root').\
            with_group('root').\
            with_content(%r{^DAEMON_USER=aptly$}).\
            with_content(%r{-config=/etc/aptly.conf})
        end

        it do
          is_expected.to contain_user('aptly').\
            with_ensure('present').\
            with_uid(450).\
            with_gid('aptly').\
            with_shell('/bin/bash')
        end

        it do
          is_expected.to contain_group('aptly').\
            with_ensure('present').\
            with_gid(450).\
            that_comes_before('User[aptly]')
        end

        it { is_expected.to contain_file('/etc/apt/sources.list.d/aptly.list') }
        it { is_expected.to contain_file('preferences.d').with_ensure('directory') }
        it { is_expected.to contain_file('sources.list.d').with_ensure('directory') }
        it { is_expected.to contain_file('sources.list') }
        it { is_expected.to contain_exec('apt_update') }

        ###
        # aptly::service
        ###
        it do
          is_expected.to create_service('aptly').\
            with_ensure('running').\
            with_enable('true').\
            with_hasstatus('true').\
            with_hasrestart('true')
        end

        ###
        # aptly::config
        ###
        it do
          is_expected.to create_file('/etc/aptly.conf').\
            with_ensure('file').\
            with_content(%r{"rootDir": "/var/aptly"}).\
            with_mode('0644').\
            with_owner('aptly').\
            with_group('aptly')
        end
        it { is_expected.to create_file('/etc/aptly.conf').with_content(%r{"downloadConcurrency": 4,}) }
        it { is_expected.to create_file('/etc/aptly.conf').with_content(%r{"architectures": \["amd64"\],}) }

        it do
          is_expected.to create_file('/var/aptly').\
            with_ensure('directory').\
            with_mode('0644').\
            with_owner('aptly').\
            with_group('aptly')
        end
      end
    end

    context 'different params enforced on supported os' do
      describe "aptly class without repo and custom user on #{os}" do
        let(:params) do
          {
            version: 'installed',
            install_repo: false,
            user: 'reposvc',
            uid: 42,
            group: 'repogrp',
            gid: 666,
            config_filepath: '/home/aptly/.aptly.cfg',
            root_dir: '/aptly'
          }
        end

        it { is_expected.to contain_package('aptly').with_ensure('installed').with_provider('apt') }
        it { is_expected.not_to contain_class('apt') }

        it { is_expected.not_to contain_apt__source('aptly') }
        it { is_expected.not_to contain_class('apt::update') }

        it do
          is_expected.to create_file('/etc/init.d/aptly').\
            with_mode('0755').\
            with_owner('root').\
            with_group('root').\
            with_content(%r{^DAEMON_USER=reposvc$})
        end

        it do
          is_expected.to contain_user('reposvc').\
            with_ensure('present').\
            with_uid(42).\
            with_gid('repogrp').\
            with_shell('/bin/bash')
        end

        it do
          is_expected.to contain_group('repogrp').\
            with_ensure('present').\
            with_gid(666).\
            that_comes_before('User[reposvc]')
        end

        it { is_expected.not_to contain_file('/etc/apt/sources.list.d/aptly.list') }
        it { is_expected.not_to contain_exec('apt_update') }

        it do
          is_expected.to create_file('/home/aptly/.aptly.cfg').\
            with_ensure('file').\
            with_content(%r{"rootDir": "/aptly"}).\
            with_mode('0644').\
            with_owner('reposvc').\
            with_group('repogrp')
        end

        it do
          is_expected.to create_file('/etc/init.d/aptly').with_content(%r{-config=/home/aptly/.aptly.cfg})
        end

        it do
          is_expected.to create_file('/aptly').\
            with_ensure('directory').\
            with_mode('0644').\
            with_owner('reposvc').\
            with_group('repogrp')
        end
      end

      context "aptly class with a version and the repo installation parameters on #{os}" do
        let(:params) do
          {
            version: '0.0.1',
            user: 'reposvc',
            uid: 42,
            group: 'repogrp',
            gid: 666,
            install_repo: true,
            repo_location: 'http://repo.mycmpany.example.com',
            repo_release: 'dummy_release',
            repo_repos: 'whatever',
            repo_keyserver: 'my.internal.keyserver',
            repo_key: 'ABC12345'
          }
        end

        it { is_expected.to contain_package('aptly').with_ensure('0.0.1').with_provider('apt') }
        it { is_expected.to contain_class('apt') }
        it { is_expected.to contain_class('apt::params') }
        it { is_expected.to contain_class('apt::update') }

        it do
          is_expected.to contain_apt__source('aptly').\
            with_location('http://repo.mycmpany.example.com').\
            with_release('dummy_release').\
            with_repos('whatever').\
            with_key('id' => 'ABC12345', 'server' => 'my.internal.keyserver').\
            with_include('src' => false, 'deb' => true).\
            that_notifies('Class[apt::update]')
        end

        it { is_expected.to contain_class('apt::update').that_comes_before('Package[aptly]') }

        it do
          is_expected.to contain_user('reposvc').\
            with_ensure('present').\
            with_uid(42).\
            with_gid('repogrp').\
            with_shell('/bin/bash')
        end

        it do
          is_expected.to contain_group('repogrp').\
            with_ensure('present').\
            with_gid(666).\
            that_comes_before('User[reposvc]')
        end

        it do
          is_expected.to create_file('/etc/init.d/aptly').\
            with_mode('0755').\
            with_owner('root').\
            with_group('root').\
            with_content(%r{^DAEMON_USER=reposvc$})
        end

        it { is_expected.to contain_file('/etc/apt/sources.list.d/aptly.list') }
        it { is_expected.to contain_file('preferences.d').with_ensure('directory') }
        it { is_expected.to contain_file('sources.list.d').with_ensure('directory') }
        it { is_expected.to contain_file('sources.list') }
        it { is_expected.to contain_exec('apt_update') }
        it { is_expected.to contain_anchor('apt_key ABC12345 present') }
      end
    end

    # Testing the parameters related to the config
    context 'limiting to specific architectures' do
      let(:params) { { architectures: %w[amd64 i386] } }

      it { is_expected.to create_file('/etc/aptly.conf').with_content(%r{"architectures": \["amd64", "i386"\],}) }
    end

    context 'using custom config properties' do
      let(:params) { { properties: { 'gpgDisableVerify' => 'true' } } }

      it { is_expected.to create_file('/etc/aptly.conf').with_content(%r{"gpgDisableVerify": true,}) }
      # Should not have the default values
      it { is_expected.not_to create_file('/etc/aptly.conf').with_content(%r{"gpgDisableSign": false,}) }
    end

    context 'adding an s3 publish endpoint' do
      let(:params) do
        { s3_publish_endpoints: {
          'test' => {
            'region'             => 'us-east-1',
            'bucket'             => 'repo',
            'awsAccessKeyID'     => '',
            'awsSecretAccessKey' => '',
            'prefix'             => '',
            'acl'                => 'public-read',
            'storageClass'       => '',
            'encryptionMethod'   => '',
            'plusWorkaround'     => 'false'
          }
        } }
      end

      it { is_expected.to create_file('/etc/aptly.conf').with_content(%r{"bucket":"repo"}) }
      it { is_expected.to create_file('/etc/aptly.conf').with_content(%r{"region":"us-east-1"}) }
    end

    context 'adding an swift publish endpoint' do
      let(:params) do
        { swift_publish_endpoints: {
          'test' => {
            'container'          => 'repo',
            'osname'             => '',
            'password'           => '',
            'prefix'             => '',
            'authurl'            => '',
            'tenant'             => '',
            'tenantid'           => '',
            'domain'             => '',
            'domainid'           => '',
            'tenantdomain'       => '',
            'tenantdomainid'     => ''
          }
        } }
      end

      it { is_expected.to create_file('/etc/aptly.conf').with_content(%r{"container":"repo"}) }
    end

    # Testing the service
    context 'enabling the service' do
      let(:params) { { enable_service: true } }

      it { is_expected.to create_class('aptly::service') }
      it do
        is_expected.to create_service('aptly').\
          with_ensure('running').\
          with_enable('true').\
          with_hasstatus('true').\
          with_hasrestart('true')
      end
    end

    context 'Disable the service' do
      let(:params) { { enable_service: false } }

      it { is_expected.to create_class('aptly::service') }
      it do
        is_expected.to create_service('aptly').\
          with_ensure('stopped').\
          with_enable('false').\
          with_hasstatus('true').\
          with_hasrestart('true')
      end
    end
    context 'Uncorrect API Bind IP address' do
      let(:params) { { api_bind: 'I_AM_A_BAD_IP' } }

      it { is_expected.to raise_error(Puppet::Error, %r{API Bind IP address is not correct}) }
    end

    context 'Enable API service' do
      let(:params)  { { enable_api: true } }

      it { is_expected.to contain_service('aptly-api').with_ensure('running') }
    end

    context 'Enable no-lock on the API' do
      let(:params)  { { enable_api: true, api_nolock: true } }

      it { is_expected.to contain_service('aptly-api').with_ensure('running') }

      it do
        is_expected.to create_file('/etc/init.d/aptly-api').\
          with_mode('0755').\
          with_owner('root').\
          with_group('root').\
          with_content(%r{-no-lock=true})
      end
    end
  end

  # Other OS-related tests
  [%w[Solaris Nexenta]].each do |osfamily, os|
    context 'unsupported operating system for repo installations' do
      describe "aptly install class without any parameters on #{osfamily}/#{os}" do
        let(:facts) do
          {
            osfamily: osfamily,
            operatingsystem: os,
            architecture: 'amd64'
          }
        end
        let(:params) { { install_repo: true } }

        it { expect { is_expected.to contain_package('aptly') }.to raise_error(Puppet::Error, %r{Installation of the repository not supported on #{os}}) }
      end
    end
    context 'untested operating system for versionned installations without repo' do
      describe "aptly install class without any parameters on #{osfamily}/#{os}" do
        let(:facts) do
          {
            osfamily: osfamily,
            operatingsystem: os,
            architecture: 'amd64'
          }
        end
        let(:params) { { version: '0.0.1', install_repo: false } }

        it { expect(Puppet::Util::Warnings.send('warnonce', "Module aptly not tested against #{os}")) }
        it { is_expected.to contain_package('aptly').with_ensure('0.0.1') }
      end
    end
    context 'untested operating system for unversionned installations without repo' do
      describe "aptly install class without any parameters on #{osfamily}/#{os}" do
        let(:facts) do
          {
            osfamily: osfamily,
            operatingsystem: os,
            architecture: 'amd64'
          }
        end
        let(:params) { { version: 'installed', install_repo: false } }

        it { expect(Puppet::Util::Warnings.send('warnonce', "Module aptly not tested against #{os}")) }
        it { is_expected.to contain_file('/etc/init.d/aptly-api') }
        it { is_expected.to contain_package('aptly').with_ensure('installed') }
      end
    end
  end
end
