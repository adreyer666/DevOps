# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

Vagrant.configure("2") do |config|
  config.vm.box = "debian/testing64"

  config.vm.hostname = "DevOps"

  config.vm.network :private_network, :ip => "192.168.124.10"
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provider :libvirt do |libvirt|
     libvirt.memory = 2048
     libvirt.cpus = 2
     #libvirt.machine_virtual_size = '30G'
     # libvirt.storage :file, :size => '40G'
  end

  config.vm.provision "shell", inline: <<-SHELL
    /vagrant/install.sh
  SHELL
end
