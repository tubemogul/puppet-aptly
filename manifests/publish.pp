# == Define aptly::publish
#
# Manages the aptly publications (of repos, mirrors and snapshots)
#
define aptly::publish (
  $source_type,
  $ensure       = 'present',
  $uid          = '450',
  $gid          = '450',
  $distribution = "${::lsbdistcodename}-${name}",
) {
  validate_string(
    $source_type,
    $distribution
  )

  aptly_publish { $name:
    ensure       => $ensure,
    uid          => $uid,
    gid          => $gid,
    source_type  => $source_type,
    distribution => $distribution,
  }
}
