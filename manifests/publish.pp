# == Define aptly::publish
#
# Manages the aptly publications (of repos, mirrors and snapshots)
#
define aptly::publish (
  $source_type,
  $ensure        = 'present',
  $uid           = '450',
  $gid           = '450',
  $distribution  = "${::lsbdistcodename}-${name}",
  $prefix        = '.',
  $architectures = undef,
  $label         = '',
) {
  validate_string(
    $source_type,
    $distribution,
    $prefix,
  )

  aptly_publish { $name:
    ensure        => $ensure,
    uid           => $uid,
    gid           => $gid,
    source_type   => $source_type,
    distribution  => $distribution,
    architectures => $architectures,
    prefix        => $prefix,
    label         => $label,
    notify        => Class['aptly::service'],
  }
}
