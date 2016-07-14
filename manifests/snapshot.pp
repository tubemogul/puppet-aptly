# == Define aptly::snapshot
#
# This definition is meant to be called from aptly.
# It manages APT Mirrors.
#
define aptly::snapshot (
  $source_type,
  $source_name,
  $ensure = 'present',
) {
  validate_string(
    $source_type,
    $source_name
  )

  aptly_snapshot { $name:
    ensure      => $ensure,
    source_type => $source_type,
    source_name => $source_name,
  }
}
