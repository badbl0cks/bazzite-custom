#!/bin/sh

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
rpm-ostree install \
        freeipa-client \
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
        git-credential-libsecret
        

# this would install a package from rpmfusion
#rpm-ostree install vlc



#### Change to System Configuration Files

# this example modifies default timeouts to prevent slow reboots from services that won't stop
#sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/user.conf
#sed -i 's/#DefaultTimeoutStopSec.*/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf
