#
# Cookbook:: nginx
# Recipe:: lua
#
# Copyright:: 2013-2017, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# execute 'setup_iptables' do
#   user 'root'
#   command 'sh /vagrant/cookbooks/nginx/recipes/iptables_setup.sh'
# end

execute 'sshd_setup' do
  user 'root'
  command 'sh /vagrant/cookbooks/nginx/recipes/sshd_config_setup.sh'
end

execute 'testhtml_setup' do
  user 'root'
  command 'mkdir -p /etc/nginx/html ; sh /vagrant/cookbooks/nginx/recipes/test_hello_world.sh > /etc/nginx/html/test.html'
end

#bash "sshd_setup2" do
#  code <<-EOH
#    su -l vagrant -c "cd /vagrant/cookbooks/nginx/recipes ; sudo sh sshd_config_setup.sh"
#  EOH
#end

# bash "install npm modules" do
#  code <<-EOH
#    su -l vagrant -c "sudo apt-get install npm -y; cd /vagrant && npm install -y"
#  EOH
#end


