
$script = <<SCRIPT
  echo "cheking network connectivity"
  sleep 120
  ping -c5 www.google.com && sudo apt-get install libpcre3 libpcre3-dev -y
  echo "ooobar"
SCRIPT

Vagrant.configure("2") do |config|

   config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all",  '--nicpromisc1', 'allow-all', '--nicpromisc2', 'allow-all']
   end

  config.vm.define "wNginx1" do |wNginx1|
    wNginx1.vm.box = 'bento/ubuntu-18.04'
    wNginx1.vm.hostname = 'wNginx1'
    wNginx1.vm.box_url = 'bento/ubuntu-18.04'
    wNginx1.vm.network "forwarded_port", guest: 22, host:3131


    wNginx1.vm.network :private_network, ip: "192.168.0.4",
     virtualbox__intnet: "vboxnet1"
    wNginx1.vm.network :private_network, ip: "192.168.99.22",
     virtualbox__intnet: "vboxnet0"
    wNginx1.vm.network :public_network, bridge: [ "virbr0" ]
    #wNginx1.vm.customize ["modifyvm", :wNginx1, "--nicpromisc3", "allow-all"]
    
    config.vm.provision "shell", inline: $script
    #config.vm.provision "shell", path: "cookbooks/nginx_install/recipes/default.rb"

    VAGRANT_JSON = JSON.parse(Pathname(__FILE__).dirname.join('nodes', 'vagrant.json').read)

    wNginx1.vm.provision :chef_solo do |chef|
       chef.custom_config_path = "CustomConfiguration.chef"
       chef.cookbooks_path = ["site-cookbooks", "cookbooks"]
       chef.roles_path = "roles"
       chef.data_bags_path = "data_bags"
       chef.provisioning_path = "/tmp/vagrant-chef"
       #chef.add_recipe "nginx_install"

       # You may also specify custom JSON attributes:
       chef.run_list = VAGRANT_JSON.delete('run_list')
       chef.json = VAGRANT_JSON
    end

    wNginx1.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "wNginx1"]
    end
  end

  config.vm.define "wNginx2" do |wNginx2|
    wNginx2.vm.box = 'bento/ubuntu-18.04'
    wNginx2.vm.hostname = 'wNginx2'
    wNginx2.vm.box_url = 'bento/ubuntu-18.04'
    wNginx2.vm.network "forwarded_port", guest: 22, host:4141

    wNginx2.vm.network :private_network, ip: "192.168.0.5",
     virtualbox__intnet: "vboxnet1"
    wNginx2.vm.network :private_network, ip: "192.168.99.24",
     virtualbox__intnet: "vboxnet0"
    wNginx2.vm.network :public_network, bridge: [ "virbr0" ]
    
    config.vm.provision "shell", inline: $script
    #config.vm.provision "shell", path: "cookbooks/nginx_install/recipes/default.rb"

    VAGRANT_JSON = JSON.parse(Pathname(__FILE__).dirname.join('nodes', 'vagrant.json').read)

    wNginx2.vm.provision :chef_solo do |chef|
       chef.custom_config_path = "CustomConfiguration.chef"
       chef.cookbooks_path = ["site-cookbooks", "cookbooks"]
       chef.roles_path = "roles"
       chef.data_bags_path = "data_bags"
       chef.provisioning_path = "/tmp/vagrant-chef"
       #chef.add_recipe "nginx_install"

       # You may also specify custom JSON attributes:
       chef.run_list = VAGRANT_JSON.delete('run_list')
       chef.json = VAGRANT_JSON
    end

    wNginx2.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "wNginx2"]
    end
  end

  config.vm.define "wHAProxy" do |wHAProxy|
    wHAProxy.vm.box = 'bento/ubuntu-18.04'
    wHAProxy.vm.hostname = 'wHAProxy'
    wHAProxy.vm.box_url = 'bento/ubuntu-18.04'
    wHAProxy.vm.network "forwarded_port", guest: 22, host:9993

    wHAProxy.vm.network :private_network, ip: "192.168.0.3",
     virtualbox__intnet: "vboxnet1"
    wHAProxy.vm.network :private_network, ip: "192.168.99.26",
     virtualbox__intnet: "vboxnet0"
    wHAProxy.vm.network :public_network, bridge: [ "virbr0" ]
    
    config.vm.provision "shell", inline: $script
    #config.vm.provision "shell", path: "cookbooks/nginx_install/recipes/default.rb"

    HAPROXY_VAGRANT_JSON = JSON.parse(Pathname(__FILE__).dirname.join('nodes', 'haproxy_vagrant.json').read)

    wHAProxy.vm.provision :chef_solo do |chef|
       chef.custom_config_path = "CustomConfiguration.chef"
       chef.cookbooks_path = ["site-cookbooks", "cookbooks"]
       chef.roles_path = "roles"
       chef.data_bags_path = "data_bags"
       chef.provisioning_path = "/tmp/vagrant-chef"
       #chef.add_recipe "nginx_install"

       # You may also specify custom JSON attributes:
       chef.run_list = HAPROXY_VAGRANT_JSON.delete('run_list')
       chef.json = HAPROXY_VAGRANT_JSON
    end

    wHAProxy.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "wHAProxy"]
    end
  end
end

