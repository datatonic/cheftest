## Cookbook Name:: openssl-source
## Attributes:: default

openssl_version = '1.0.2f'
openssl_abi_version = '1.0.2'
default['openssl_source']['openssl']['version'] = openssl_version
default['openssl_source']['openssl']['abi_version'] = openssl_abi_version
default['openssl_source']['openssl']['prefix']  = "/opt/openssl-#{openssl_abi_version}"
default['openssl_source']['openssl']['url'] = "http://www.openssl.org/source/openssl-#{openssl_version}.tar.gz"
default['openssl_source']['openssl']['checksum'] = '932b4ee4def2b434f85435d9e3e19ca8ba99ce9a065a61524b429a9d5e9b2e9c'
default['openssl_source']['openssl']['configure_flags'] = %W[ shared ]
