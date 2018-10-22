# == Define aptly::repo
#
# Manages an apt repo.
#
define aptly::repo (
  $ensure               = 'present',
  $uid                  = '450',
  $gid                  = '450',
  $config_filepath      = '/etc/aptly.conf',
  $default_distribution = $::lsbdistcodename,
  $default_component    = 'main',
) {
  validate_string(
    $default_distribution,
    $default_component
  )

  aptly_repo { $name:
    ensure               => $ensure,
    uid                  => $uid,
    gid                  => $gid,
    config_filepath      => $config_filepath,
    default_distribution => $default_distribution,
    default_component    => $default_component,
  }
}
