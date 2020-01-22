# == Class: aptly
#
# Main class. See README.markdown for more documentation.
#
class aptly (
  String                 $version                 = $aptly::params::version,
  Boolean                $install_repo            = $aptly::params::install_repo,
  String                 $repo_location           = $aptly::params::repo_location,
  String                 $repo_release            = $aptly::params::repo_release,
  String                 $repo_repos              = $aptly::params::repo_repos,
  String                 $repo_keyserver          = $aptly::params::repo_keyserver,
  Pattern['^[A-F0-9]+$'] $repo_key                = $aptly::params::repo_key,
  Boolean                $enable_service          = $aptly::params::enable_service,
  Stdlib::Port           $port                    = $aptly::params::port,
  Stdlib::IP::Address    $bind                    = $aptly::params::bind,
  String                 $config_filepath         = $aptly::params::config_filepath,
  Boolean                $manage_user             = $aptly::params::manage_user,
  String                 $user                    = $aptly::params::user,
  Integer                $uid                     = $aptly::params::uid,
  String                 $group                   = $aptly::params::group,
  Integer                $gid                     = $aptly::params::gid,
  String                 $root_dir                = $aptly::params::root_dir,
  Array                  $architectures           = $aptly::params::architectures,
  String                 $ppa_dist                = $aptly::params::ppa_dist,
  String                 $ppa_codename            = $aptly::params::ppa_codename,
  Hash                   $properties              = $aptly::params::properties,
  Hash                   $s3_publish_endpoints    = $aptly::params::s3_publish_endpoints,
  Hash                   $swift_publish_endpoints = $aptly::params::swift_publish_endpoints,
  Boolean                $enable_api              = $aptly::params::enable_api,
  Stdlib::Port           $api_port                = $aptly::params::api_port,
  Stdlib::IP::Address    $api_bind                = $aptly::params::api_bind,
  Boolean                $api_nolock              = $aptly::params::api_nolock,
  Boolean                $manage_xz_utils         = $aptly::params::manage_xz_utils,
  Boolean                $recurse_root_dir        = $aptly::params::recurse_root_dir,
) inherits aptly::params {
  deprecation('root_dir', 'Please configure this via properties => rootDir')
  deprecation('architectures', 'Please configure this via properties => architectures')
  deprecation('ppa_dist', 'Please configure this via properties => ppaDistributorID')
  deprecation('ppa_codename', 'Please configure this via properties => ppaCodename')
  deprecation('s3_publish_endpoints', 'Please configure this via properties => S3PublishEndpoints')
  deprecation('swift_publish_endpoints', 'Please configure this via properties => SwiftPublishEndpoints')

  class { 'aptly::install': }
  -> class { 'aptly::config':  }
  ~> class { 'aptly::service': }

  contain aptly::install
  contain aptly::config
  contain aptly::service
}
