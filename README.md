# ublue-custom &nbsp; [![bluebuild build badge](https://github.com/badbl0cks/bazzite-custom/actions/workflows/build.yml/badge.svg)](https://github.com/badbl0cks/bazzite-custom/actions/workflows/build.yml)

See the [BlueBuild docs](https://blue-build.org/how-to/setup/) for quick setup instructions for setting up your own repository based on this template.

After setup, it is recommended you update this README to describe your custom image.

## Installation

> **Warning**
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.
First, install Bazzite normally, then rebase to this custom version!

To rebase an existing atomic Fedora installation to this build, including Bazzite:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/badbl0cks/bazzite-badblocks-gnome:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/badbl0cks/bazzite-badblocks-gnome:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```

## Images

Currently the following images are available:
- bazzite-badblocks-gnome
- bazzite-badblocks-gnome-nvidia-open


## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/badbl0cks/bazzite-custom
```
