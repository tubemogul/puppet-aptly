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
    * [Basic example](#basic-example)
    * [Enable aptly API endpoint](#enable-aptly-api-endpoint)
    * [Create an apt mirror](#create-an-apt-mirror)
    * [Create and drop apt repositories](#create-and-drop-apt-repositories)
    * [Create an aptly snapshot](#create-an-aptly-snapshot)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
  * [Public classes and defines](#public-classes-and-defines)
  * [Private classes](#private-classes)
  * [Providers and types](#providers-and-types)
  * [Parameters](#parameters)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module installs the [aptly](www.aptly.info) Debian packages repository manager and configures it.

Need help of want a new feature? File an issue on our github repository: https://github.com/tubemogul/puppet-aptly/issues

## Module Description

What is this module capable of doing?

 * Installing the aptly package in a specific version (or just the latest available)
 * Managing a specific user and group (with their corresponding fixed uid/gid) dedicated to the service
 * Configuring a specific debian repository (optional) where to find the package
 * Managing the `/etc/aptly.conf` file
 * Enabling/starting or disabling the service
 * Enabling/starting or disabling the API
 * Managing the init.d service file
 * Managing apt mirrors, repositories, snapshots and publications

The aptly service will listen on port you configure (example: 8080) on every interfaces (configurable)
using the `aptly serve -listen=":8080"` command.

If you want to make the repository being served by an apache, nginx or whatever
else, just disable the service and setup the http server you want for the HTTP(S)
layer in addition to this module.

## Setup

### What aptly affects

Files managed by the module:

 * `/etc/aptly.conf`
 * `/etc/apt/sources.list.d/aptly.list` (optional)
 * `/etc/init.d/aptly`

### Setup Requirements

The module requires:
 * [Puppetlabs stdlib](https://github.com/puppetlabs/puppetlabs-stdlib.git)
 * [Puppetlab's APT module](https://github.com/puppetlabs/puppetlabs-apt.git) at least version 2.0.x

### Beginning with aptly

The module can be used out of the box directly, it just requires puppetlabs' apt
module and its stdlib to be in your modulepath.

To install:

```
puppet module install TubeMogul/aptly
```

Puppet will install the dependencies automatically, but if you want to install
the dependencies 1 by 1, you can use this before:

```
puppet module install puppetlabs/stdlib
puppet module install puppetlabs/apt
```

## Usage

**WARNING:** the aptly service won't start as long as nothing has been published
in it. It is a totally expected behavior coming from aptly itself.

Those examples include the puppet-only configuration, and the corresponding
configuration for those who use hiera (I find it more convenient for copy/paste
of a full configuration when you have both - yes, I'm lazy ;-) ).

### Basic example

The default values are normally sane enough to do as few parameters overwrites
as possible.

But let's say you want:
 * Aptly to store its data in `/data` (that you created before hand)
 * to only have the architectures `i386` and `amd64`
 * to have your ppa codename to be `foo`

Then you just do:
```puppet
class { 'aptly':
  root_dir      => '/data',
  architectures => ['i386', 'amd64'],
  ppa_codename  => 'foo',
}
```

Or using hiera:
```yaml
---
aptly::root_dir: /data
aptly::architectures:
  - i386
  - amd64
aptly::ppa_codename: foo
```

**NOTE:** this will also install the official aptly repo in your sources.list.d.

### Enable aptly API endpoint

To:
 * enable the aptly API management
 * make the API listen on port `42000`
 * have the API listen on the private interface of your server (let's say this interface's IP is `10.0.0.123`)
 * have the API configured in no-lock mode as you are doing both cli and API calls

Then you can do:
```puppet
class { 'aptly':
  enable_api => true,
  api_port   => 42000,
  api_bind   => '10.0.0.123',
  api_nolock => true,
}
```

Or using hiera:
```yaml
---
aptly::enable_api: true
aptly::api_port: 42000
aptly::api_bind: 10.0.0.123
aptly::api_nolock: true
```

### Create an apt mirror

**Warning:** after creating the mirror, the update of the mirror from its source
is initiated. This can take a significant amount of time.

To create an APT repository:
 * of the Debian US repo
 * of the stable distribution
 * only taking the main component
 * only for the amd64 architecture

Use:
```puppet
aptly::mirror { 'debian_stable':
  location      => 'http://ftp.us.debian.org/debian/',
  distribution  => 'stable',
  components    => [ 'main' ],
  architectures => ['amd64'],
}
```

**Note:** This module does not manage the gpg keys directly, so if you don't take care of adding the gpg file of your target repository,
you'll end up with the following error:

```
Error: /Stage[main]/Main/Aptly::Mirror[debian_stable]/Aptly_mirror[debian_stable]/ensure: change from absent to present failed: Execution of 'aptly -architectures=amd64 -with-sources=false -with-udebs=false mirror create debian_stable http://ftp.us.debian.org/debian/ stable main' returned 1: Looks like your keyring with trusted keys is empty. You might consider importing some keys.
If you're running Debian or Ubuntu, it's a good idea to import current archive keys by running:

  gpg --no-default-keyring --keyring /usr/share/keyrings/debian-archive-keyring.gpg --export | gpg --no-default-keyring --keyring trustedkeys.gpg --import

(for Ubuntu, use /usr/share/keyrings/ubuntu-archive-keyring.gpg)

Downloading http://ftp.us.debian.org/debian/dists/stable/InRelease...
Downloading http://ftp.us.debian.org/debian/dists/stable/Release...
Downloading http://ftp.us.debian.org/debian/dists/stable/Release.gpg...
gpgv: Signature made Sat Jun  4 08:26:51 2016 GMT+5 using RSA key ID 46925553
gpgv: Can't check signature: public key not found
gpgv: Signature made Sat Jun  4 08:26:51 2016 GMT+5 using RSA key ID 2B90D010
gpgv: Can't check signature: public key not found
gpgv: Signature made Sat Jun  4 08:36:26 2016 GMT+5 using RSA key ID 518E17E1
gpgv: Can't check signature: public key not found

Looks like some keys are missing in your trusted keyring, you may consider importing them from keyserver:

gpg --no-default-keyring --keyring trustedkeys.gpg --keyserver keys.gnupg.net --recv-keys 8B48AD6246925553 7638D0442B90D010 CBF8D6FD518E17E1

Sometimes keys are stored in repository root in file named Release.key, to import such key:

wget -O - https://some.repo/repository/Release.key | gpg --no-default-keyring --keyring trustedkeys.gpg --import

ERROR: unable to fetch mirror: verification of detached signature failed: exit status 2
```

Here's a full example of how you can manage your gpg keys along with the mirror:
```puppet
aptly::mirror { 'debian_stable':
  location      => 'http://ftp.us.debian.org/debian/',
  distribution  => 'stable',
  components    => [ 'main'] ,
  architectures => ['amd64'],
}

exec { 'debian_stable_key_8B48AD6246925553':
  command => '/usr/bin/gpg --no-default-keyring --keyring trustedkeys.gpg --keyserver keys.gnupg.net --recv-key 8B48AD6246925553',
  unless  => '/usr/bin/gpg --no-default-keyring --keyring trustedkeys.gpg --list-key 8B48AD6246925553 > /dev/null 2>&1',
}

exec { 'debian_stable_key_7638D0442B90D010':
  command => '/usr/bin/gpg --no-default-keyring --keyring trustedkeys.gpg --keyserver keys.gnupg.net --recv-key 7638D0442B90D010',
  unless  => '/usr/bin/gpg --no-default-keyring --keyring trustedkeys.gpg --list-key 7638D0442B90D010 > /dev/null 2>&1',
}

exec { 'debian_stable_key_CBF8D6FD518E17E1':
  command => '/usr/bin/gpg --no-default-keyring --keyring trustedkeys.gpg --keyserver keys.gnupg.net --recv-key CBF8D6FD518E17E1',
  unless  => '/usr/bin/gpg --no-default-keyring --keyring trustedkeys.gpg --list-key CBF8D6FD518E17E1 > /dev/null 2>&1',
}


Exec['debian_stable_key_8B48AD6246925553']->
Exec['debian_stable_key_7638D0442B90D010']->
Exec['debian_stable_key_CBF8D6FD518E17E1']->
Aptly::Mirror['debian_stable']
```

### Create and drop apt repositories

Using the `aptly::repo` is really simple. In this example, we will:
 * drop the `my_custom_repo` repository
 * create the `tubemogul_apps` repository (with "stable" as default component
   for publishing)

Use:
```puppet
# Dropping the 'my_custom_repo' repo
aptly::repo {'my_custom_repo':
  ensure => absent,
}

# Making sure that the 'tubemogul_apps' exists with the expected parameters
aptly::repo {'tubemogul_apps':
  default_component => 'stable',
}
```

Once you've done that, you can add packages using the `aptly repo add tubemogul_apps my_package.deb` or using the API.

### Create an aptly snapshot

Once you've created your repo and added packages to it, you might want to take a
snapshot of a stable stack or a coherent ensemble to publish it later.

This example creates a snapshot named `nightly_20160823` based on the repository
`tubemogul_apps` that we created in the previous example:

```puppet
aptly::snapshot { 'nightly_20160823':
  source_type => 'repository',
  source_name => 'tubemogul_apps',
}
```

## Reference

### Public classes and defines

 * [`aptly`](#class-aptly): Installs and configures the aptly server.
 * [`aptly::mirror`](#define-aptlymirror): Manages an aptly mirror.
 * [`aptly::repo`](#define-aptlyrepo): Manages an aptly repository.
 * [`aptly::snapshot`](#define-aptlysnapshot): Manages an aptly snapshot.
 * [`aptly::publish`](#define-aptlypublish): Manages an aptly publication.

### Private classes

 * `aptly::install`: Installs the aptly server.
 * `aptly::config`: Configures the aptly server.
 * `aptly::service`: Manages the aptly server and the API services.

### Providers and types

To manage the aptly resources, this modules embeds the following custom
types and corresponding providers (to be accessed via the public defines):

 * `aptly_mirror` to manage an aptly mirror
 * `aptly_repo` to manage an aptly repository
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

Boolean to manage whether or not you want to have a sources.list repo
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

Default : `8080`

##### `bind`

IP address of the Aptly webserver (`0.0.0.0` or empty string meaning that you
listen on all interfaces).

Default: `0.0.0.0`

##### `config_filepath`

Path of the configuration file to be used by the aptly service.

Default: `/etc/aptly.conf`

##### `manage_user`
Whethere should this module manage aptly user or not

Default: `true`

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

Root directory to use for storing the repo data.

Default: `/var/aptly`

##### `architectures`

Architectures managed by the repo.

Default: `["amd64"]`

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

##### `swift_publish_endpoints`

Hash to describe the SwiftPublishEndpoints property of the aptly.conf.

Default: `{}`

##### `enable_api`

Enable Aptly API by starting the service

Default : `false`

##### `api_port`

Port for the Aptly API service.

Default : `8081`

##### `api_bind`

Binding address for the Aptly API service.

Default : `0.0.0.0`

##### `api_nolock`

If `true`, the API service will not lock the database (for situations where you
heavily use both the API and the cli for example).

Default : `false`

##### `manage_xz_utils`

Boolean to enable or disable installation of the xz-utils package (required
dependency for aptly).

Default : `true`

#### Define aptly::mirror

##### `ensure`

Ensures if the mirror must be `present` (should exist) or `absent` (or be
destroyed).

Default: `present`

##### `uid`

UID of the OS user which will run the cli

Default: `450`

##### `gid`

GID of the OS user which will run the cli

Default: `450`

##### `location`

Location of the repository to mirror.

Default: `undef`

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

Mirror the sources packages or not.

Default: `false`

##### `with_udebs`

Download the .udeb packages.

Default: `false`

#### Define aptly::repo

##### `ensure`

Ensures if the repository must be `present` (should exist) or `absent` (or be
destroyed).

Default: `present`

##### `uid`

UID of the OS user which will run the cli

Default: `450`

##### `gid`

GID of the OS user which will run the cli

Default: `450`

##### `default_distribution`

Default distribution (used only when publishing).

Default: `$::lsbdistcodename`

##### `default_component`

Default component (used only when publishing).

Default: `main`

#### Define aptly::snapshot

##### `ensure`

Ensures if the snapshot must be `present` (should exist) or `absent` (or be
destroyed).

Default: `present`

##### `uid`

UID of the OS user which will run the cli

Default: `450`

##### `gid`

GID of the OS user which will run the cli

Default: `450`

##### `source_type`

Type of source to snapshot. Correct values are:

 * `mirror`
 * `repo`
 * `empty`

Default: `undef`

##### `source_name`

Name of the source to create snapshot from.

Default: `undef`

#### Define aptly::publish

##### `ensure`

Ensures that the publication is `present` (should exist) or `absent` (or should be
destroyed).

Default: `present`

##### `uid`

UID of the OS user which will run the cli

Default: `450`

##### `gid`

GID of the OS user which will run the cli

Default: `450`

##### `source_type`

Type of source to publish. Supported values are:

 * `repo`
 * `snapshot`

Default: `undef`

##### `distribution`

Distribution name to publish.

Default: `"${::lsbdistcodename}-${name}"`

##### `endpoint`

The endpoint to publish to.

Default: `undef`

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

We're actually nice people and we rarely bite, so you're more than welcome to
contribute to our repos via the usual GitHub PR and issues.

What we ask generally is that when you push a change or a new functionnality,
you add the corresponding tests at the same time. You'll find a lot of tests
examples in this repository.

See the [CONTRIBUTING.md](https://github.com/tubemogul/puppet-aptly/blob/master/CONTRIBUTING.md) file for more detailed guidelines.

