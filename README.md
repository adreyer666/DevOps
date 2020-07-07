# DevOps

Setup a DevOps virtual machine for general development and deployment.

```
apt install -y \
	qemu-system-x86 qemu-kvm \
	qemu-utils qemu-block-extra
apt install -y \
	libvirt-daemon libvirt-daemon-system libvirt-daemon-driver-qemu \
	libvirt-clients
systemctl start libvirtd
apt install -y \
	vagrant \
	vagrant-libvirt

apt install -y git ssvnc

git clone https://github.com/adreyer666/DevOps.git
cd DevOps
vagrant up
vagrant ssh-config >> ~/.ssh/config

ssh DevOps
```

