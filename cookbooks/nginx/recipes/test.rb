
execute 'setup_iptables' do
  user 'root'
  command 'sh iptables_setup.sh'
end

execute 'sshd_setup' do
  user 'root'
  command 'sh sshd_config_setup.sh'
end

bash "sshd_setup2" do
  code <<-EOH
    su -l vagrant -c "cd /vagrant/cookbooks/nginx/recipes ; sudo sh sshd_config_setup.sh"
  EOH
end

# bash "install npm modules" do
#  code <<-EOH
#    su -l vagrant -c "sudo apt-get install npm -y; cd /vagrant && npm install -y"
#  EOH
#end


