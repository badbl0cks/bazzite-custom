#!/bin/sh

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


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
        sunshine \
        firewall-config \
        alsa-tools \
        libappstream-glib

# from rpmfusion
rpm-ostree install vlc

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

# this example modifies default timeouts to prevent slow reboots from services that won't stop
#sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf
#sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf
