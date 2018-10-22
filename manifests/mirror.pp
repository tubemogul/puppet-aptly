# == Define aptly::mirror
#
# Manages an apt mirror.
#
define aptly::mirror (
  $location,
  $ensure          = 'present',
  $uid             = '450',
  $gid             = '450',
  $config_filepath = '/etc/aptly.conf',
  $distribution    = $::lsbdistcodename,
  $architectures   = [],
  $components      = [],
  $with_sources    = false,
  $with_udebs      = false,
) {
  validate_string( $distribution)
  validate_array(
    $architectures,
    $components
  )
  validate_bool(
    $with_sources,
    $with_udebs
  )
  validate_re($location, ['\Ahttps?:\/\/', '\Aftp:\/\/', '\A\/\w+'])

  aptly_mirror { $name:
    ensure          => $ensure,
    uid             => $uid,
    gid             => $gid,
    config_filepath => $config_filepath,
    location        => $location,
    distribution    => $distribution,
    architectures   => $architectures,
    components      => $components,
    with_sources    => $with_sources,
    with_udebs      => $with_udebs,
  }
}
