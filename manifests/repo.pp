# == Define aptly::repo
#
# Manages an apt repo.
#
define aptly::repo (
  $ensure               = 'present',
  $uid                  = '450',
  $gid                  = '450',
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
    default_distribution => $default_distribution,
    default_component    => $default_component,
  }
}
