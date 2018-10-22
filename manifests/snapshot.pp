# == Define aptly::snapshot
#
# This definition is meant to be called from aptly.
# It manages APT Mirrors.
#
define aptly::snapshot (
  $source_type,
  $source_name,
  $ensure          = 'present',
  $uid             = '450',
  $gid             = '450',
  $config_filepath = '/etc/aptly.conf',
) {
  validate_string(
    $source_type,
    $source_name
  )

  aptly_snapshot { $name:
    ensure          => $ensure,
    uid             => $uid,
    gid             => $gid,
    config_filepath => $config_filepath,
    source_type     => $source_type,
    source_name     => $source_name,
  }
}
