# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

# Using some code from https://github.com/joatmon08/vagrantfiles/tree/master/kubernetes

NUM_WORKERS = 1

Vagrant.configure("2") do |config|
  config.vm.define "master", primary: true do |master|

    master.vm.box = "ubuntu/xenial64"
    master.vm.hostname = 'master'
    master.vm.network :private_network, ip: "192.168.205.10"

    master.vm.provider :virtualbox do |v|
      v.memory = '1500'
      #v.customize ["modifyvm", :id, "--memory", 1500]
      v.cpus = 2
    end
    master.vm.provision :shell, path: "./bootstrap.sh"
  end

  (1..NUM_WORKERS).each do |n|
    config.vm.define "node#{n}", primary: true do |node|

      node.vm.box = "ubuntu/xenial64"
      node.vm.hostname = "node#{n}"
      node.vm.network :private_network, ip: "192.168.205.1#{n}"

      node.vm.provider :virtualbox do |v|
        v.memory = '500'
        #v.customize ["modifyvm", :id, "--memory", 500]
      end
      node.vm.provision :shell, path: "./bootstrap.sh"
    end
  end
end
