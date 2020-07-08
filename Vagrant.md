# Vagrant

* https://docs.vagrantup.com
* Search boxes at https://vagrantcloud.com/search

---

## Install and setup
```
sudo apt install -y vagrant vagrant-libvirt
vagrant version
vagrant plugin list
vagrant plugin install vagrant-disksize
vagrant plugin install vagrant-libvirt
vagrant box list

vagrant init
# edit Vagrantfile
vagrant up

vagrant halt
vagrant up
vagrant reload
vagrant destroy -f
```

### Debug
`export VAGRANT_LOG=debug`

---

## Vagrant and Libvirt

* https://computingforgeeks.com/using-vagrant-with-libvirt-on-linux/
* https://github.com/vagrant-libvirt/vagrant-libvirt
* https://blogs.oracle.com/linux/getting-started-with-the-vagrant-libvirt-provider-for-oracle-linux

---

