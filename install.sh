#!/bin/sh -f

DEBIAN_FRONTEND=noninteractive; export DEBIAN_FRONTEND

apt-get update
apt-get upgrade -y

apt-get install -y --no-install-recommends \
	curl ca-certificates gpg sudo \
	xauth x11-apps xterm \
	libxtst6 libasound2 \
	fakeroot gpg-agent xdg-utils \
	git jq \
	build-essential \
	pandoc fonts-dejavu

apt-get install -y --no-install-recommends \
    python3 python3-dev python3-pip python3-wheel \
    python3-pytest pylint flake8 pyflakes3

# podman & kubernetes
apt-get install -y --no-install-recommends \
    ansible \
    podman buildah umoci \
    kubernetes-client kubetail


mkdir -p /usr/local/src
cd /usr/local/src
# add x11docker to run X11 container apps
git clone https://github.com/mviereck/x11docker.git
cp x11docker/x11docker /usr/local/bin
chmod 755 /usr/local/bin/x11docker


# add python IDE container
git clone https://github.com/adreyer666/Python-IDE.git
cd Python-IDE
make
cp python-ide /usr/local/bin
chmod 755 /usr/local/bin/python-ide


