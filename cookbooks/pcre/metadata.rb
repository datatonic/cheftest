name             'pcre'
maintainer       'Panagiotis Papadomitsos'
maintainer_email 'pj@ezgr.net'
license          'Apache 2.0'
description      'Configures and installs a self-contained PCRE installation'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION')).chomp rescue '0.1.0'

recipe 'pcre', 'Configures and installs a self-contained PCRE installation'

supports 'ubuntu',      '>= 12.04'
supports 'debian',      '>= 6.0'
supports 'redhat',      '>= 6.0'
supports 'scientific',  '>= 6.0'
supports 'oracle',      '>= 6.0'

depends 'build-essential'
