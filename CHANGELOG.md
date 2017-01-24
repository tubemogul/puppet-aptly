# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

## [3.1.0] - 2017-01-23
## Added
- The "distribution" parameter to the aptly::publish define
- A uid and gid to use when running the aptly command-line to avoid to run those
  as root and redefine the rights on the aerospike directory every time

## Changed
- Default architectures from an empty array to an array containing only amd64 to
  avoid ending up with a default ./public/pool directory

## Dropped
- The version-dependent files have been dropped (aka Gemfile.lock)

## [3.0.0] - 2017-01-08
### Added
- Add the support for Debian 8 in the metadata.json to be able to find the
  module more easily while filtering in the forge.
- Add the support for SwiftPublishEndpoints.
- The package xz-utils is now managed by the module.

### Changed
- Change the default aptly port to avoid having troubles with the aptly user
  unable to bind ports under 1024. This change is the cause of this version
  to be a major version and not a minor version.
- Move the current changelog to a semver format.
- Several indentation, lint and rubocop cleanups have been integrated.
- The Travis tests matrix has been changed to speed up the tests and focus on
  the most important environments.
- The documentation received some fixes and additions.

### Fixed
- Fix a syntax issue in the init script preventing, in some configurations, the
  aptly service from starting.
- Fix the recurse permissions on the root directory of aptly.
- Fix permissions on init script to make it executables not only by root.
- Fix the integers validation for the ports.
- Better handling of the exists? function in the providers, plus getting it
  uniform. There were some issues with that were leading to the recreation of
  the resources every time you run puppet.
- When running aptly as a non-root user, the cli was generating files that the
  aptly user could not read, causing troubles.  Those permissions are now
  managed by Puppet.

### Dropped
- Drop the support of the CONTRIBUTORS file as it was maintained manually
  and can anyway be checked in the git logs or via the github api.


## [2.1.0] - 2016-08-22
### Added
- Adding aptly_repo type and provider and aptly::repo define and add
  documentation for them.
- Adding the params class to the specs

### Fixed
- Fixing exist? function for publish and repo providers

## [2.0.2] - 2016-08-22
### Added
- Adding an example of how to create a mirror

### Fixed
- Fixing issues with broken providers
- Fixing "WARNING: quoted boolean value found"

## [2.0.1] - 2016-08-17
### Fixed
- Forcing the -config parameter on the aptly service to ensure the right config
  is taken
- Fixing the declaration of the no-lock flag in the aptly-api service making the
  API not start when no-lock was enable
- Fix some issues in the documentation

## [2.0.0] - 2016-08-04
### Added
- Adding documentation
- Adding the possiblity of setting up mirrors, snapshots and publications
  directly via puppet
- Adding the management of the API

### Changed
- The following parameters have been renamed for a better coherence:
 * aptly::rootDir => aptly::root_dir (was already available with this name in hiera),
 * aptly::config_arch => aptly::architectures (was already available with this name in hiera),
 * aptly::config_props => aptly::properties (was already available with this name in hiera),
 * aptly::s3publishpson => aptly::s3_publish_endpoints (was available under aptly::s3PublishEndpoints in hiera before)

## [1.0.2] - 2015-07-03
### Added
- Adding CI public tools integration

### Changed
- Cleaning up the different supported versions
- Updating the dependecies list in metdata.json

###Removed
- Dropping the support for version 2.7 as not supported by the dependencies
  (puppetlabs/apt module)

## [1.0.1] - 2015-06-06
### Changed
- Cleanup code quality warnings

## [1.0.0] - 2015-06-05
### Added
- Initial public release
