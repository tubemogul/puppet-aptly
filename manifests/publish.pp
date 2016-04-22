# == Define aptly::publish
#
define aptly::publish (
  $source_type,
  $source_name = $name,
  $ensure      = 'present',
) {
  validate_string(
    $source_type,
    $source_name
  )

  aptly_publish { $source_name:
    ensure      => $ensure,
    source_type => $source_type,
  }
}
