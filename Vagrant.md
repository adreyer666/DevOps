# Vagrant

* https://docs.vagrantup.com
* Search boxes at https://vagrantcloud.com/search

---

## Install and setup
```
apt install -y vagrant
vagrant version
vagrant init

# edit Vagrantfile

vagrant up
vagrant box list
vagrant plugin list

## vagrant plugin install vagrant-libvirt


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

