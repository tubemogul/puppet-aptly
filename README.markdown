#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with aptly](#setup)
    * [What aptly affects](#what-aptly-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with aptly](#beginning-with-aptly)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module installs the [aptly](www.aptly.info) Deb package repository manager and configures it.

It has been tested and used in production with:

 * Puppet 3.7 on Ubuntu 14.04 (trusty)

It doesn't use the hiera automatic lookup functionnality of Puppet 3 to be
compatible with Puppet 2.7 (not fully tested against it tho).

## Module Description

What is this module capable to do?

 * Install the aptly package in a specific version
 * Manage a specific user and group (with their corresponding fixed uid/gid) dedicated to the service
 * Configure a specific debian repository (optional) where to find the package
 * Manage the /etc/aptly.conf file
 * Enable/start or disable the service (you can specify this in hiera)
 * Manages the init.d service file
 
The aptly service will listen on port 80 on every interfaces using the
`aptly serve -listen=":80"` command.
If you want to make the repository beeing served by an apache, nginx or whatever
else, just disable the service and setup the http server you want for the HTTP(S)
layer in addition to this module.

## Setup

### What aptly affects

Warning:

 * This module don't manage your mirrors or repos. It manages the installation,
   configuration and start/stop of the service. The creation of the mirrors is
   on your plate.

Files managed by the module:

 * /etc/aptly.conf
 * /etc/apt/sources.list.d/aptly.list (optional)
 * /etc/init.d/aptly

### Setup Requirements

The module requires:
 - [Puppetlabs stdlib](https://github.com/puppetlabs/puppetlabs-stdlib.git)
 - [Puppetlab's APT module](https://github.com/puppetlabs/puppetlabs-apt.git) at
   least version 2.0.x

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
class { 'stdlib': } -> class { 'aptly': }
```

NOTE: this will also install the official aptly repo in your sources.list.d.

## Development

See the CONTRIBUTING.md file.

## TODO

There are still some work to do on this module including:

 * write acceptance tests
 * write smoke tests
 * test the module against other platforms
