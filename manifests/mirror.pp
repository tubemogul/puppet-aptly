# == Define aptly::mirror
#
# This definition is meant to be called from aptly.
# It manages APT Mirrors.
#
define aptly::mirror (
  $location,
  $ensure        = 'present',
  $distribution  = $::lsbdistcodename,
  $architectures = [],
  $components    = [],
  $with_sources  = false,
  $with_udebs    = false,
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
    ensure        => $ensure,
    location      => $location,
    distribution  => $distribution,
    architectures => $architectures,
    components    => $components,
    with_sources  => $with_sources,
    with_udebs    => $with_udebs
  }
}
