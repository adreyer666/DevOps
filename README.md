# DevOps

Setup a DevOps virtual machine for general development and deployment.

```
apt install -y \
	git ssvnc \
	qemu-system-x86 qemu-kvm qemu-utils qemu-block-extra \
	libvirt-daemon libvirt-daemon-system libvirt-daemon-driver-qemu \
	libvirt-clients \
	vagrant vagrant-libvirt
systemctl start libvirtd

git clone https://github.com/adreyer666/DevOps.git
cd DevOps
vagrant up
grep 'Include' ~/.ssh/config || echo 'Include config.d/*.conf' >> ~/.ssh/config
vagrant ssh-config >> ~/.ssh/config.d/default.conf

ssh -X DevOps
```

