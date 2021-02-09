# == Define aptly::mirror
#
# Manages an apt mirror.
#
define aptly::mirror (
  $location,
  $ensure           = 'present',
  $uid              = '450',
  $gid              = '450',
  $distribution     = $::lsbdistcodename,
  $architectures    = [],
  $components       = [],
  $with_sources     = false,
  $with_udebs       = false,
  $filter           = undef,
  $filter_with_deps = false,
) {
  validate_string($distribution)
  validate_array(
    $architectures,
    $components
  )
  validate_bool(
    $with_sources,
    $with_udebs,
    $filter_with_deps
  )
  validate_re($location, ['\Ahttps?:\/\/', '\Aftp:\/\/', '\A\/\w+'])

  aptly_mirror { $name:
    ensure           => $ensure,
    uid              => $uid,
    gid              => $gid,
    location         => $location,
    distribution     => $distribution,
    architectures    => $architectures,
    components       => $components,
    with_sources     => $with_sources,
    with_udebs       => $with_udebs,
    filter           => $filter,
    filter_with_deps => $filter_with_deps,
  }
}
