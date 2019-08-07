#
# Cookbook Name:: pcre
# Recipe:: default
#
# Copyright (C) 2013 Panagiotis Papadomitsos
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'build-essential'

# For pcregrep-libbz2
case node['platform_family']
when 'debian'
  package 'libbz2-1.0'
  package 'libbz2-dev'
when 'rhel','fedora','amazon','scientific'
  package 'bzip2-devel'
  package 'bzip2-libs'
end

Chef::Log.info(node.to_hash)

pcre_filename = ::File.basename(node['pcre']['url'])
pcre_path = "#{Chef::Config['file_cache_path'] || '/tmp'}/pcre-#{node['pcre']['version']}"
pcre_install_path = "#{node['pcre']['prefix']}/pcre-#{node['pcre']['version']}"

node.run_state['pcre_configure_flags'] = [
  '--enable-pcregrep-libz',
  '--enable-pcregrep-libbz2',
  '--enable-newline-is-anycrlf'
]

node.run_state['pcre_configure_flags'] |= [ '--enable-unicode-properties', '--enable-utf' ] if node['pcre']['enable_utf8']
node.run_state['pcre_configure_flags'] |= [ '--enable-jit' ] if node['pcre']['enable_jit']

remote_file "#{Chef::Config['file_cache_path'] || '/tmp'}/#{pcre_filename}" do
  owner 'root'
  group 'root'
  mode 00644
  source node['pcre']['url']
  checksum node['pcre']['checksum']
  action :create
end

execute 'extract-pcre' do
  user 'root'
  cwd(Chef::Config['file_cache_path'] || '/tmp')
  command "tar xjf #{pcre_filename}"
  not_if { ::File.directory?(pcre_path) }
end

bash 'compile-pcre' do
  user 'root'
  cwd pcre_path
  code <<-EOH
  ./configure --prefix=#{pcre_install_path} --sysconfdir=/etc --localstatedir=/var \\
  #{node.run_state['pcre_configure_flags'].join(' ')} &&
  make
  EOH
  creates "#{pcre_path}/.libs/libpcre.so"
end

execute 'install-pcre' do
  command 'make install-strip'
  cwd pcre_path
  creates "#{pcre_install_path}/lib/libpcre.so"
  notifies :create, 'file[/etc/ld.so.conf.d/pcre.conf]'
  action :run
end

file '/etc/ld.so.conf.d/pcre.conf' do
  action :nothing
  owner 'root'
  group 'root'
  mode 00644
  content <<-EOH
# Custom PCRE installation - Generate by Chef
#{pcre_install_path}/lib
EOH
  notifies :run, 'execute[ldconfig]'
  only_if { node['pcre']['add_ldconfig'] }
end

execute 'ldconfig' do
  action :nothing
end

node.run_state.delete('pcre_configure_flags')
