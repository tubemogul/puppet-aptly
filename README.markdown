# Aptly Puppet module

[![TravisBuild](https://travis-ci.org/tubemogul/puppet-aptly.svg?branch=master)](https://travis-ci.org/tubemogul/puppet-aptly)
[![Puppet Forge latest release](https://img.shields.io/puppetforge/v/TubeMogul/aptly.svg)](https://forge.puppetlabs.com/TubeMogul/aptly)
[![Puppet Forge downloads](https://img.shields.io/puppetforge/dt/TubeMogul/aptly.svg)](https://forge.puppetlabs.com/TubeMogul/aptly)
[![Puppet Forge score](https://img.shields.io/puppetforge/f/TubeMogul/aptly.svg)](https://forge.puppetlabs.com/TubeMogul/aptly/scores)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with aptly](#setup)
    * [What aptly affects](#what-aptly-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with aptly](#beginning-with-aptly)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
  * [Public classes and defines](#public-classes-and-defines)
  * [Private classes](#private-classes)
  * [Providers and types](#providers-and-types)
  * [Parameters](#parameters)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module installs the [aptly](www.aptly.info) Deb package repository manager and configures it.

Need help of want a new feature? File an issue on our github repository: https://github.com/tubemogul/puppet-maxscale/issues

## Module Description

What is this module capable to do?

 * Install the aptly package in a specific version (or just the latest available)
 * Manage a specific user and group (with their corresponding fixed uid/gid) dedicated to the service
 * Configure a specific debian repository (optional) where to find the package
 * Manage the /etc/aptly.conf file
 * Enable/start or disable the service
 * Enable/start or disable the API
 * Manages the init.d service file
 * Manage apt mirrors, snapshots, publications
 
The aptly service will listen on port 80 on every interfaces (configurable) using the `aptly serve -listen=":80"` command.

If you want to make the repository beeing served by an apache, nginx or whatever
else, just disable the service and setup the http server you want for the HTTP(S)
layer in addition to this module.

## Setup

### What aptly affects

Files managed by the module:

 * /etc/aptly.conf
 * /etc/apt/sources.list.d/aptly.list (optional)
 * /etc/init.d/aptly

### Setup Requirements

The module requires:
 - [Puppetlabs stdlib](https://github.com/puppetlabs/puppetlabs-stdlib.git)
 - [Puppetlab's APT module](https://github.com/puppetlabs/puppetlabs-apt.git) at least version 2.0.x

### Beginning with aptly

The module can be used out of the box directly, it just requires puppetlabs' apt
module and its stdlib to be in your modulepath.

To install (with all the dependencies):

```
puppet module install puppetlabs/stdlib
puppet module install puppetlabs/apt
puppet module install tubemogul/aptly
```

## Usage

Basic usage example:
```
class { 'aptly': }
```

NOTE: this will also install the official aptly repo in your sources.list.d.

## Reference

### Public classes and defines

 * [`aptly`](#class-aptly): Installs and configures the aptly server.
 * [`aptly::mirror`](#define-aptly--mirror): Manages an aptly mirror.
 * [`aptly::snapshot`](#define-aptly--snapshot): Manages an aptly snapshot.
 * [`aptly::publish`](#define-aptly--publish): Manages an aptly publication.

### Private classes

 * `aptly::install`: Installs the aptly server.
 * `aptly::config`: Configures the aptly server.
 * `aptly::service`: Manages the aptly server and the API services.

### Providers and types

To manage the aptly resources, this modules embeds the following custom
types and corresponding providers (to be accessed via the public defines):

 * `aptly_mirror` to manage an aptly mirror
 * `aptly_snapshot` to manage an aptly snapshot
 * `aptly_publish` to manage an aptly publication

### Parameters

#### Class aptly

##### `version`

Aptly version to ensure to install.
You can use a version number to force a version or just use `installed` or
`latest` to benefit from the usual Puppet behavior.

Default: `installed`

##### `install_repo`

Boolean to manage wether or not you want to have a sources.list repo
managed by the module.

Default: `true`

##### `repo_location`

Location of the remote repo to manage when using `install_repo` to `true`.

Default: `http://repo.aptly.info`

##### `repo_release`

Release of the repo to use when using `install_repo` to `true`.

Default: `squeeze`

##### `repo_repos`

Repo name to use in the repo when using `install_repo` to `true`.

Default: `main`

##### `repo_keyserver`

Key server to use to retreive the key of the repo when using `install_repo`
to `true`.

Default: `keys.gnupg.net`

##### `repo_key`

Key used by the signed repo when using `install_repo` to `true`.

Default: `DF32BC15E2145B3FA151AED19E3E53F19C7DE460`

##### `enable_service`

Boolean to enable or disable the service.

Default: `true` (service enabled)

##### `port`

Port for the Aptly webserver

Default : `80`

##### `bind`

IP address of the Aptly webserver (`0.0.0.0` or empty string meaning that you
listen on all interfaces).

Default: `0.0.0.0`

##### `config_filepath`

Path of the configuration file to be used by the aptly service.

Default: `/etc/aptly.conf`

##### `user`

OS user which will run the service.

Default: `aptly`

##### `uid`

UID of the OS user which will run the service.

Default: `450`

##### `group`

Group of the OS user which will run the service.

Default: `aptly`

##### `gid`

GID of the group of the OS user which will run the service.

Default: `450`

##### `root_dir`

Root directory to use as root for storing the repo data.

Default: `/var/aptly`

##### `architectures`

Architectures managed by the repo.

Default: `[]` (empty means all architectures)

##### `ppa_dist`

Distribution code of the ppa to serve.

Default: `ubuntu`

##### `ppa_codename`

Codename of the ppa to serve.

Default: `''`


##### `properties`

Hash containing the optional properties of the aptly.conf. The key is the
property name and the value is its value!

Default:

```
{
  'downloadConcurrency'         => 4,
  'downloadSpeedLimit'          => 0,
  'dependencyFollowSuggests'    => false,
  'dependencyFollowRecommends'  => false,
  'dependencyFollowAllVariants' => false,
  'dependencyFollowSource'      => false,
  'gpgDisableSign'              => false,
  'gpgDisableVerify'            => false,
  'downloadSourcePackages'      => false,
}
```


##### `s3_publish_endpoints`

Hash to describe the s3PublishEndpoints property of the aptly.conf.

Default: `{}`

##### `enable_api`

Enable Aptly API by starting the service

Default : `false`

##### `api_port`

Port for the Aptly API service.

Default : `8080`

##### `api_bind`

Binding address for the Aptly API service.

Default : `0.0.0.0`

##### `api_nolock`

If `true`, the API service will not lock the database (for situations where you
heavily use both the API and the cli for example).

Default : `false`


#### Define aptly::mirror

##### `location`

Location of the repository to mirror.

Default: `undef`

##### `ensure`

Ensures if the mirror must be `present` (should exist) or `absent` (or be
destroyed).

Default: `present`

##### `distribution`

Distribution to mirror.

Default: `$::lsbdistcodename`

##### `architectures`

Architectures to mirror.

Default: `[]`

##### `components`

Components to mirror.

Default: `[]`

##### `with_sources`

Mirror the sources or not.

Default: `false`

##### `with_udebs`

Download the .udeb packages.

Default: `false`

#### Define aptly::snapshot

##### `source_type`

Type of source to snapshot. Correct values are:

 * `mirror`
 * `repo`
 * `empty`

Default: `undef`

##### `source_name`

Name of the source to create snapshot from.

Default: `undef`

##### `ensure`

Ensures if the snapshot must be `present` (should exist) or `absent` (or be
destroyed).

Default: `present`

#### Define aptly::publish

##### `source_type`

Type of source to publish. Supported values are:

 * `repo`
 * `snapshot`

Default: `undef`

##### `source_name`

Name of the source to publish.

Default: `undef`

##### `ensure`

Ensures if the publication must be `present` (should exist) or `absent` (or be
destroyed).

Default: `present`



## Limitations

This module has been tested against Puppet 3.8 with Ubuntu clients.

The spec tests work on Puppet 3.7+ and 4.x.

To work on Debian OS family servers, it requires the apt module from Puppetlabs
to be installed if you want to have this module manage your aptly repository (optionnal).

The implementation for the installation on other operating systems has not been
done yet but should be pretty straightforward to do. Just ask which one you want
and we'll add it or submit a pull request on our github page and we'll integrate
it.


## Development

See the CONTRIBUTING.md file.

