#!/bin/sh

set -oex pipefail
set +u

RELEASE="$(rpm -E %fedora)"

### Add repos
rpm-ostree install https://download.docker.com/linux/fedora/docker-ce.repo

### Refresh repos
rpm-ostree refresh-md

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# from fedora repos
# NOTE: for now freeipa-client must be layered AFTER installation to work
rpm-ostree install \
        usbguard \
        zsh \
        libvirt \
        virt-manager \
        autofs \
        gstreamer1-plugins-ugly-free \
        gstreamer1-plugins-bad-free \
        gstreamer1-plugins-bad-free-extras \
        gstreamer1-plugins-good \
        gstreamer1-plugins-good-extras \
        gstreamer1-plugins-base \
        gstreamer1-plugins-base-tools \
        wireguard-tools \
        trash-cli \
        git \
        git-credential-libsecret \
        gtk-murrine-engine \
        firewall-config \
        alsa-tools \
        libappstream-glib \
        htop \
        glances \
        ansible

# from dnf groups (gh actions will translate this to rpm-ostree install <pkgs>)
rpm-ostree groupinstall "C Development Tools and Libraries" "Development Tools"

# from rpmfusion
rpm-ostree install \
        vlc

# from custom repos
rpm-ostree install \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

# TODO: Add rpm building with FPM

# from RPMs on Github
# Space-separated list of repo/package strings
repos="quexten/goldwarden"

# Loop through each repo/package
for repo_package in $repos; do
    # Split the string into repo and package using parameter expansion
    repo=${repo_package%/*}
    package=${repo_package#*/}

    # Fetch the latest release download URL for .rpm assets
    download_url=$(wget -qO- "https://api.github.com/repos/$repo/$package/releases/latest" \
        | jq -r '.assets[] | select(.name | match(".rpm")) | .browser_download_url')

    # Download the asset as <PACKAGE>.rpm
    wget -qO "$package.rpm" "$download_url"

    # Install the package
    rpm-ostree install "$package.rpm"
done


#### Change to System Configuration Files
# Enable docker.service
ln -s /etc/systemd/system/docker.service /etc/systemd/system/multi-user.target.wants/

# this example modifies default timeouts to prevent slow reboots from services that won't stop
#sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf
#sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf
