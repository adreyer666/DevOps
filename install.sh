#!/bin/sh -f

DEBIAN_FRONTEND=noninteractive; export DEBIAN_FRONTEND

apt-get update -q
apt-get upgrade -q -y
apt-get dist-upgrade -q -y

apt-get install -q -y --no-install-recommends \
    procps iproute2 iptables nftables \
    curl ca-certificates sudo \
    vim-tiny openssh-client gpg gpg-agent lrzip \
    xauth x11-apps x11-utils xterm \
    libxtst6 libasound2 xdg-utils \
    git jq \
    build-essential fakeroot \
    pandoc fonts-dejavu sshpass

apt-get install -q -y --no-install-recommends \
    python3 python3-dev python3-pip python3-wheel \
    python3-pytest pylint flake8 pyflakes3 python3-tk \
    python3-setuptools \
    python3-autopep8 \
    python3-flake8 python3-flake8-docstrings \
    python3-mccabe \
    python3-pytest

# add more utils and GUI apps
apt-get install -q -y --no-install-recommends \
    zsh meld gitk \
    sqlitebrowser \
    audacious firefox-esr

# podman & kubernetes
echo 'deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Testing/ /' > /etc/apt/sources.list.d/libcontainers.list
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_Testing/Release.key | apt-key add -
apt-get update
apt-get install -q -y --no-install-recommends \
    lxcfs lxc-templates \
    vagrant vagrant-libvirt vagrant-lxc \
    ansible \
    containers-storage \
    podman-rootless buildah runc umoci slirp4netns tini \
    kubernetes-client kubetail

# cleanup
apt-get install -f
apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apt/archives/partial


# ---- add some local configurations/tools ---- #
# activate user namespaces
echo "kernel.unprivileged_userns_clone=1" >> /etc/sysctl.d/10-userns.conf
sysctl -p /etc/sysctl.d/10-userns.conf
# system
echo 'net.ipv4.ip_forward = 1' > /etc/sysctl.d/10-ip_forward.conf
sysctl -p /etc/sysctl.d/10-ip_forward.conf
cat > /etc/sysctl.d/k8s.conf <<EOM
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOM
sysctl --system
swapoff -a

# ---- staging area ---- #
# user
su - vagrant -c "git config --global pull.ff only"
mkdir -p /usr/local/src
mkdir -p /usr/local/bin

# vagrant
su - vagrant -c "vagrant plugin install vagrant-libvirt"
#su - vagrant -c "vagrant plugin install vagrant-proxmox"
#su - vagrant -c "vagrant plugin install vagrant-disksize"

# terraform
V=0.12.28
mkdir -p /usr/local/src/terraform/${V}
cd /usr/local/src/terraform/${V}
cat > hashicorp.asc <<EOM
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQENBFMORM0BCADBRyKO1MhCirazOSVwcfTr1xUxjPvfxD3hjUwHtjsOy/bT6p9f
W2mRPfwnq2JB5As+paL3UGDsSRDnK9KAxQb0NNF4+eVhr/EJ18s3wwXXDMjpIifq
fIm2WyH3G+aRLTLPIpscUNKDyxFOUbsmgXAmJ46Re1fn8uKxKRHbfa39aeuEYWFA
3drdL1WoUngvED7f+RnKBK2G6ZEpO+LDovQk19xGjiMTtPJrjMjZJ3QXqPvx5wca
KSZLr4lMTuoTI/ZXyZy5bD4tShiZz6KcyX27cD70q2iRcEZ0poLKHyEIDAi3TM5k
SwbbWBFd5RNPOR0qzrb/0p9ksKK48IIfH2FvABEBAAG0K0hhc2hpQ29ycCBTZWN1
cml0eSA8c2VjdXJpdHlAaGFzaGljb3JwLmNvbT6JAU4EEwEKADgWIQSRpuf4XQXG
VjC+8YlRhS2HNI/8TAUCXn0BIQIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAK
CRBRhS2HNI/8TJITCACT2Zu2l8Jo/YLQMs+iYsC3gn5qJE/qf60VWpOnP0LG24rj
k3j4ET5P2ow/o9lQNCM/fJrEB2CwhnlvbrLbNBbt2e35QVWvvxwFZwVcoBQXTXdT
+G2cKS2Snc0bhNF7jcPX1zau8gxLurxQBaRdoL38XQ41aKfdOjEico4ZxQYSrOoC
RbF6FODXj+ZL8CzJFa2Sd0rHAROHoF7WhKOvTrg1u8JvHrSgvLYGBHQZUV23cmXH
yvzITl5jFzORf9TUdSv8tnuAnNsOV4vOA6lj61Z3/0Vgor+ZByfiznonPHQtKYtY
kac1M/Dq2xZYiSf0tDFywgUDIF/IyS348wKmnDGjuQENBFMORM0BCADWj1GNOP4O
wJmJDjI2gmeok6fYQeUbI/+Hnv5Z/cAK80Tvft3noy1oedxaDdazvrLu7YlyQOWA
M1curbqJa6ozPAwc7T8XSwWxIuFfo9rStHQE3QUARxIdziQKTtlAbXI2mQU99c6x
vSueQ/gq3ICFRBwCmPAm+JCwZG+cDLJJ/g6wEilNATSFdakbMX4lHUB2X0qradNO
J66pdZWxTCxRLomPBWa5JEPanbosaJk0+n9+P6ImPiWpt8wiu0Qzfzo7loXiDxo/
0G8fSbjYsIF+skY+zhNbY1MenfIPctB9X5iyW291mWW7rhhZyuqqxN2xnmPPgFmi
QGd+8KVodadHABEBAAGJATwEGAECACYCGwwWIQSRpuf4XQXGVjC+8YlRhS2HNI/8
TAUCXn0BRAUJEvOKdwAKCRBRhS2HNI/8TEzUB/9pEHVwtTxL8+VRq559Q0tPOIOb
h3b+GroZRQGq/tcQDVbYOO6cyRMR9IohVJk0b9wnnUHoZpoA4H79UUfIB4sZngma
enL/9magP1uAHxPxEa5i/yYqR0MYfz4+PGdvqyj91NrkZm3WIpwzqW/KZp8YnD77
VzGVodT8xqAoHW+bHiza9Jmm9Rkf5/0i0JY7GXoJgk4QBG/Fcp0OR5NUWxN3PEM0
dpeiU4GI5wOz5RAIOvSv7u1h0ZxMnJG4B4MKniIAr4yD7WYYZh/VxEPeiS/E1CVx
qHV5VVCoEIoYVHIuFIyFu1lIcei53VD6V690rmn0bp4A5hs+kErhThvkok3c
=+mCN
-----END PGP PUBLIC KEY BLOCK-----
EOM
gpg --import hashicorp.asc
## curl -Lo SHA256SUMS  https://releases.hashicorp.com/terraform/${V}/terraform_${V}_SHA256SUMS
## curl -Lo SHA256SUMS.sig https://releases.hashicorp.com/terraform/${V}/terraform_${V}_SHA256SUMS.sig
## curl -Lo terraform_linux_amd64.zip https://releases.hashicorp.com/terraform/${V}/terraform_${V}_linux_amd64.zip
## gpg --verify SHA256SUMS.sig SHA256SUMS
## shasum -a 256 -c SHA256SUMS
## unzip terraform_linux_amd64.zip
## chown root: terraform
## chmod 755 terraform
## cp -av terraform /usr/local/bin

## # add terraform-provider-proxmox
## cd /usr/local/src
## git clone https://github.com/Telmate/terraform-provider-proxmox.git
## cd terraform-provider-proxmox
## cp bin/terraform-provider-proxmox $$GOPATH/bin/terraform-provider-proxmox
## cp bin/terraform-provisioner-proxmox $$GOPATH/bin/terraform-provisioner-proxmox

# zsh
mkdir -p /usr/local/src/ohmyzsh
cd /usr/local/src/ohmyzsh
curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
su - vagrant -c "/bin/sh /usr/local/src/ohmyzsh/install.sh --unattended"
chsh -s /bin/zsh vagrant


# ---- get/build some containers ---- #

# prep for x11docker
apt-get install -q -y --no-install-recommends \
    xinit xpra nxagent xvfb tini
mkdir -p /usr/local/share/x11docker/
ln -s /usr/bin/tini /usr/local/share/x11docker/tini-static

# add x11docker to run X11 container apps
cd /usr/local/src
git clone https://github.com/mviereck/x11docker.git
cp x11docker/x11docker /usr/local/bin
chmod 755 /usr/local/bin/x11docker

# add python IDE container
cd /usr/local/src
git clone https://github.com/adreyer666/Python-IDE.git
cd Python-IDE
cp python-ide /usr/local/bin
chmod 755 /usr/local/bin/python-ide
su - vagrant -c "(cd /usr/local/src/Python-IDE && make)"

chown -R vagrant: /usr/local/src


