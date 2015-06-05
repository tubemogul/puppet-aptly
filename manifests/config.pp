# == Class aptly::config
#
# This class is called from aptly for service config.
#
class aptly::config {

  #Setting File defaults:
  File {
    mode  => '0644',
    owner => $aptly::user,
    group => $aptly::group,
  }

  file { $aptly::config_filepath:
    ensure  => file,
    content => template('aptly/aptly.conf.erb'),
  }

  file { $aptly::rootDir:
    ensure => directory,
    mode   => '0755',
  }

}
