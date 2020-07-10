#!/bin/sh -f

DEBIAN_FRONTEND=noninteractive; export DEBIAN_FRONTEND

apt-get update
apt-get upgrade -q -y

apt-get install -q -y --no-install-recommends \
    procps iproute2 \
    curl ca-certificates gpg sudo \
    lrzip iptables \
    xauth x11-apps x11-utils xterm \
    libxtst6 libasound2 \
    fakeroot gpg-agent xdg-utils \
    git jq sshpass \
    build-essential \
    pandoc fonts-dejavu

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
    ansible \
    containers-storage \
    podman buildah runc umoci slirp4netns tini \
    kubernetes-client kubetail

# cleanup
apt-get install -f
apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apt/archives/partial

# ---- get/build some containers ---- #

# activate user namespaces
echo "kernel.unprivileged_userns_clone=1" >> /etc/sysctl.d/10-userns.conf
sysctl -p /etc/sysctl.d/10-userns.conf

mkdir -p /usr/local/src

# zsh
mkdir /usr/local/src/ohmyzsh
cd /usr/local/src/ohmyzsh
curl -Lo install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
su - vagrant -c "/bin/sh /usr/local/src/ohmyzsh/install.sh --unattended"
chsh -s /bin/zsh vagrant

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

