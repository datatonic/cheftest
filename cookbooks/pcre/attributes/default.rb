#
# Cookbook Name:: pcre
# Attribute:: default
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

default['pcre']['version']      = '8.35'
default['pcre']['url']          = "http://downloads.sourceforge.net/project/pcre/pcre/#{node['pcre']['version']}/pcre-#{node['pcre']['version']}.tar.bz2"
default['pcre']['checksum']     = 'a961c1c78befef263cc130756eeca7b674b4e73a81533293df44e4265236865b'
default['pcre']['prefix']       = '/opt'

default['pcre']['add_ldconfig'] = false
default['pcre']['enable_jit']   = true
default['pcre']['enable_utf8']  = true
