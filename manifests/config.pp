# == Class aptly::config
#
# This class is called from the aptly class for service configuration.
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

  file { $aptly::root_dir:
    ensure  => directory,
    mode    => '0644',
    recurse => $aptly::recurse_root_dir,
  }

}
