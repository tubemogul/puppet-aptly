# == Define aptly::publish
#
# Manages the aptly publications (of repos, mirrors and snapshots)
#
define aptly::publish (
  $source_type,
  $source_name = $name,
  $ensure      = 'present',
  $config      = undef,
) {
  validate_string(
    $source_type,
    $source_name
  )

  aptly_publish { $source_name:
    ensure      => $ensure,
    source_type => $source_type,
    notify      => Class['aptly::service'],
  }
}
