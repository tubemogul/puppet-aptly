# == Class aptly::config
#
# This class is called from the aptly class for service configuration.
#
class aptly::config {

  #Setting File defaults:
  File {
    mode  => '0644',
    owner => $aptly::user,
    group => $aptly::group,
  }

  # This can be removed once the parameters in here are removed
  $backwards_compatibility_config = {
    'rootDir'               => $aptly::root_dir,
    'architectures'         => $aptly::architectures,
    'ppaDistributorID'      => $aptly::ppa_dist,
    'ppaCodename'           => $aptly::ppa_codename,
    'S3PublishEndpoints'    => $aptly::s3_publish_endpoints,
    'SwiftPublishEndpoints' => $aptly::swift_publish_endpoints,
  }

  $config = deep_merge($aptly::params::properties, $aptly::properties, $backwards_compatibility_config)

  file { $aptly::config_filepath:
    ensure  => file,
    content => to_json_pretty($config),
  }

  file { $config['rootDir']:
    ensure  => directory,
    mode    => '0644',
    recurse => true,
  }

}
