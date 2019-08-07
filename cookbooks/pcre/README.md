Description
===========

The PCRE cookbook configures and installs a self-contained (as in, installed in /opt),
version installation of the Perl Compatible Regular Expression library. Useful for
statically/dynamically linkining to niche apps.

Requirements
============

Cookbooks
---------

This cookbook depends on the `build-essential` cookbook, used for building
the library.

Platform
--------

The following platforms are supported and tested under test kitchen:

* Ubuntu 12.04, 12.10
* CentOS 6

Other Debian and RHEL family distributions are assumed to work.

Chef Server
-----------

The cookbook converges best on Chef installations >= 10.16.2

Attributes
==========

The following attributes are available on this cookbook:

* `node['pcre']['version']` - The PCRE version installed
* `node['pcre']['url']` - The URL that servers the PCRE source tree
* `node['pcre']['checksum']` - The SHA-256 checksum of the above archive
* `node['pcre']['prefix']` - The prefix directory in which PCRE will be installed

* `node['pcre']['add_ldconfig']` - Creates the /etc/ld.so.conf.d/pcre.conf file with
  the library installation prefix in order to include it to ldconfig loading
* `node['pcre']['enable_jit']` - Enables the JIT compile of PCRE
* `node['pcre']['enable_utf8']` - Enable UTF-8 support in PCRE

Recipes
=======

## default.rb

The default recipe downloads, compiles and installs the selected 
PCRE version in in $PREFIX/pcre-$VERSION

Usage
=====

Include the recipe on your node or role. Modify the
attributes as required in your role to change how various
configuration is applied per the attributes section above. In general,
override attributes in the role should be used when changing
attributes.

License and Author
==================

- Author:: Panagiotis Papadomitsos (<pj@ezgr.net>)

Copyright 2013, Panagiotis Papadomitsos

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
