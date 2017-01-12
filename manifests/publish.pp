# == Define aptly::publish
#
# Manages the aptly publications (of repos, mirrors and snapshots)
#
define aptly::publish (
  $source_type,
  $distribution = "${::lsbdistcodename}-${name}",
  $ensure       = 'present',
) {
  validate_string(
    $source_type,
    $distribution
  )

  aptly_publish { $name:
    ensure       => $ensure,
    source_type  => $source_type,
    distribution => $distribution,
    notify       => Class['aptly::service'],
  }
}
