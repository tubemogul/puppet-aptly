# == Class: aptly
#
# Main class. See README.markdown for more documentation.
#
class aptly (
  $version              = $aptly::params::version,
  $install_repo         = $aptly::params::install_repo,
  $repo_location        = $aptly::params::repo_location,
  $repo_release         = $aptly::params::repo_release,
  $repo_repos           = $aptly::params::repo_repos,
  $repo_keyserver       = $aptly::params::repo_keyserver,
  $repo_key             = $aptly::params::repo_key,
  $enable_service       = $aptly::params::enable_service,
  $port                 = $aptly::params::port,
  $bind                 = $aptly::params::bind,
  $config_filepath      = $aptly::params::config_filepath,
  $manage_user          = $aptly::params::manage_user,
  $user                 = $aptly::params::user,
  $uid                  = $aptly::params::uid,
  $group                = $aptly::params::group,
  $gid                  = $aptly::params::gid,
  $root_dir             = $aptly::params::root_dir,
  $architectures        = $aptly::params::architectures,
  $ppa_dist             = $aptly::params::ppa_dist,
  $ppa_codename         = $aptly::params::ppa_codename,
  $properties           = $aptly::params::properties,
  $s3_publish_endpoints = $aptly::params::s3_publish_endpoints,
  $swift_publish_endpoints = $aptly::params::swift_publish_endpoints,
  $enable_api           = $aptly::params::enable_api,
  $api_port             = $aptly::params::api_port,
  $api_bind             = $aptly::params::api_bind,
  $api_nolock           = $aptly::params::api_nolock,
  $manage_xz_utils      = $aptly::params::manage_xz_utils,
) inherits aptly::params {

  validate_string(
    $version,
    $user,
    $group,
    $repo_location,
    $repo_release,
    $repo_repos,
    $repo_keyserver,
    $config_filepath,
    $user,
    $group,
    $root_dir)
  if ! is_integer($uid) { fail("invalid ${uid} provided") }
  if ! is_integer($gid) { fail("invalid ${gid} provided") }
  validate_re($repo_key, '^[A-F0-9]+$')
  validate_bool(
    $install_repo,
    $enable_service,
    $enable_api,
    $api_nolock)
  validate_array($architectures)
  validate_hash($properties)
  validate_hash($s3_publish_endpoints)
  validate_hash($swift_publish_endpoints)
  validate_integer($port, 49150)
  validate_integer($api_port, 49150)
  validate_re(
    $bind,
    '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$',
    'Aptly Bind IP address is not correct'
  )
  validate_re(
    $api_bind,
    '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$',
    'API Bind IP address is not correct'
  )

  deprecation('root_dir', 'Please configure this via properties => rootDir')
  deprecation('architectures', 'Please configure this via properties => architectures')
  deprecation('ppa_dist', 'Please configure this via properties => ppaDistributorID')
  deprecation('ppa_codename', 'Please configure this via properties => ppaCodename')
  deprecation('s3_publish_endpoints', 'Please configure this via properties => S3PublishEndpoints')
  deprecation('swift_publish_endpoints', 'Please configure this via properties => SwiftPublishEndpoints')

  class { '::aptly::install': } -> class { '::aptly::config':  } ~> class { '::aptly::service': } -> Class['::aptly']
}
