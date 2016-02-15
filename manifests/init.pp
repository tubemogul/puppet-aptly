# == Class: aptly
#
# Main class to manage Aptly repo manager.
# Only tested on Ubuntu Trusty and Puppet 3.7 but designed to also be compatible
# Puppet 2.7 for now.
#
# === Parameters
#
# [*version*]
#   Aptly version to ensure to install.
#   You can use a version number to force a version
#   or just use 'installed' (default) or 'latest' to have the usual Puppet
#   behavior.
#
# [*install_repo*]
#   Boolean to manage wether or not you want to have a sources.list repo
#   managed by the module.
#
# [*repo_location*]
#   Location of the remote repo to manage when using 'install_repo' to true.
#   Defaults to the official aptly repo (http://repo.aptly.info).
#
# [*repo_release*]
#   Release of the repo to use when using 'install_repo' to true.
#   Default to squeeze which is the default stable version for the debian-based
#   installations.
#
# [*repo_repos*]
#   Repo name to use in the repo when using 'install_repo' to true.
#   Defaults to 'main'.
#
# [*repo_keyserver*]
#   Key server to use to retreive the key of the repo when using 'install_repo'
#   to true.
#   Defaults to 'keys.gnupg.net'.
#
# [*repo_key*]
#   Key used by the signed repo when using 'install_repo' to true.
#   Default is 'B6140515643C2AE155596690E083A3782A194991' which is currently
#   the fingerprint of the key used in the official Aptly APT repository.
#
# [*enable_service*]
#   Boolean to enable or disable the service.
#   Defaults to true (service enabled)
#
# [*port*]
#   Port for the Aptly webserver
#   Default : 80
#
# [*bind*]
#   IP address of the Aptly webserver
#   Default : 0.0.0.0
#
# [*user*]
#   OS user which will run the service. Default is aptly.
#   Defaults to 'aptly'.
#
# [*uid*]
#   UID of the OS user which will run the service. Default is aptly.
#   Defaults to 450.
#
# [*group*]
#   Group of the OS user which will run the service. Default is aptly.
#   Defaults to 'aptly'.
#
# [*gid*]
#   GID of the group of the OS user which will run the service. Default is aptly.
#   Defaults to 450.
#
# [*rootDir*]
#   Root directory to use as root for storing the repo data.
#
# [*config_arch*]
#   Architectures managed by the repo. Empty means all.
#   Defaults to all.
#
# [*ppa_dist*]
#   Distribution code of the ppa to serve. Defaults to ubuntu.
#
# [*ppa_codename*]
#   Codename of the ppa to serve. Defaults to ubuntu.
#
# [*config_props*]
#   Hash containing the optional properties of the aptly.conf.
#
# [*s3publishpson*]
#   Hash to describe the s3PublishEndpoints property of the aptly.conf.
#   Defaults to empty.
#
# [*enable_api*]
#   Enable Aptly API by starting the service
#   Default : false
#
# [*api_port*]
#   Port for the Aptly API service.
#   Default : 8080
#
# [*api_bind*]
#   Binding address for the Aptly API service.
#   Default : 0.0.0.0
#
class aptly (
  $version         = hiera('aptly::version', 'installed'),
  $install_repo    = hiera('aptly::install_repo', true),
  $repo_location   = hiera('aptly::repo_location', 'http://repo.aptly.info'),
  $repo_release    = hiera('aptly::repo_release', 'squeeze'),
  $repo_repos      = hiera('aptly::repo_repos', 'main'),
  $repo_keyserver  = hiera('aptly::repo_keyserver', 'keys.gnupg.net'),
  $repo_key        = hiera('aptly::repo_key', 'B6140515643C2AE155596690E083A3782A194991'),
  $enable_service  = hiera('aptly::enable_service', true),
  $port            = hiera('aptly::port', '80'),
  $bind            = hiera('aptly::bind', '0.0.0.0'),
  $config_filepath = hiera('aptly::config_filepath', '/etc/aptly.conf'),
  $user            = hiera('aptly::user', 'aptly'),
  $uid             = hiera('aptly::uid', 450),
  $group           = hiera('aptly::group', 'aptly'),
  $gid             = hiera('aptly::gid', 450),
  $rootDir         = hiera('aptly::root_dir', '/var/aptly'),
  $config_arch     = hiera('aptly::architectures', []),
  $ppa_dist        = hiera('aptly::ppa_dist', 'ubuntu'),
  $ppa_codename    = hiera('aptly::ppa_codename', ''),
  $config_props    = hiera('aptly::properties', {
    'downloadConcurrency'         => 4,
    'downloadSpeedLimit'          => 0,
    'dependencyFollowSuggests'    => false,
    'dependencyFollowRecommends'  => false,
    'dependencyFollowAllVariants' => false,
    'dependencyFollowSource'      => false,
    'gpgDisableSign'              => false,
    'gpgDisableVerify'            => false,
    'downloadSourcePackages'      => false,
    }),
  $s3publishpson   = hiera('aptly::s3PublishEndpoints', {}),
  $enable_api      = hiera('aptly::enable_api', false),
  $api_port        = hiera('aptly::api_port', 8080),
  $api_bind        = hiera('aptly::api_bind', '0.0.0.0'),
) {

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
    $rootDir)
  if ! is_integer($uid) { fail("invalid ${uid} provided") }
  if ! is_integer($gid) { fail("invalid ${gid} provided") }
  validate_re($repo_key, '^[A-F0-9]+$')
  validate_bool(
    $install_repo,
    $enable_service,
    $enable_api)
  validate_array($config_arch)
  validate_hash($config_props)
  validate_hash($s3publishpson)
  validate_integer(
    $port,
    $api_port
  )
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

  class { 'aptly::install': } ->
  class { 'aptly::config':  } ~>
  class { 'aptly::service': } ->
  Class['::aptly']
}
