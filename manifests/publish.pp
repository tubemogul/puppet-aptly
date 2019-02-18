# == Define aptly::publish
#
# Manages the aptly publications (of repos, mirrors and snapshots)
#
define aptly::publish (
  $source_type,
  $ensure          = 'present',
  $uid             = '450',
  $gid             = '450',
  $config_filepath = '/etc/aptly.conf',
  $distribution    = "${::lsbdistcodename}-${name}",
  $endpoint        = undef,
) {
  validate_string(
    $source_type,
    $distribution
  )

  aptly_publish { $name:
    ensure          => $ensure,
    uid             => $uid,
    gid             => $gid,
    config_filepath => $config_filepath,
    source_type     => $source_type,
    distribution    => $distribution,
    endpoint        => $endpoint,
  }
}
