# == Class aptly::install
#
# This class is called from the aptly class for installing the service.
#
class aptly::install {

  if ! defined(User[$aptly::user]) {
    user { $aptly::user:
      ensure  => present,
      uid     => $aptly::uid,
      gid     => $aptly::group,
      shell   => '/bin/bash',
      require => Group[$aptly::group],
    }
  }

  if ! defined(Group[$aptly::group]) {
    group { $aptly::group:
      ensure => present,
      gid    => $aptly::gid,
    }
  }

  # Dealing with package default provider
  case $::osfamily {
    'Debian': {
      Package { provider => 'apt', }
    }
    default: {
      # The package has not been tested on other OS.
      # The default provider is needed when specifying
      # a version or latest in $aptly_version
      warning("Module aptly not tested against ${::operatingsystem}")
    }
  }

  # Dealing with specific repo installation
  if $aptly::install_repo == true {
    case $::osfamily {
      'Debian': {

        include 'apt'

        apt::source { 'aptly':
          location => $aptly::repo_location,
          release  => $aptly::repo_release,
          repos    => $aptly::repo_repos,
          key      => {
            id     => $aptly::repo_key,
            server => $aptly::repo_keyserver,
          },
          include  => {
            src => false,
            deb => true,
          },
        }

        Apt::Source['aptly'] ~>
        Class['apt::update'] ->
        Package['aptly']
      }
      default: {
        fail("Installation of the repository not supported on ${::operatingsystem}")
      }
    }
  }

  package { 'aptly':
    ensure   => $aptly::version,
  }

  file{ '/etc/init.d/aptly':
    ensure  => present,
    content => template('aptly/aptly.init.d.erb'),
    mode    => '0744',
    owner   => 'root',
    group   => 'root',
  }

  $nolock = $aptly::api_nolock ? {
    true  => '--no-lock-true',
    false => '',
  }

  $api_opts = "--listen ${aptly::api_bind}:${aptly::api_port} ${nolock}"

  file{ '/etc/init.d/aptly-api':
    ensure  => present,
    content => template('aptly/aptly-api.init.d.erb'),
    mode    => '0744',
    owner   => 'root',
    group   => 'root',
  }
}
