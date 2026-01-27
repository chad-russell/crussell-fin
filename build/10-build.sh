#!/usr/bin/env bash

set -eoux pipefail

###############################################################################
# Main Build Script
###############################################################################
# This script follows the @ublue-os/bluefin pattern for build scripts.
# It uses set -eoux pipefail for strict error handling and debugging.
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Copy Custom Files"

cp -a /ctx/oci/common/shared/. /
cp -a /ctx/oci/common/bluefin/. /
cp -a /ctx/oci/brew/. /

# Copy Brewfiles to standard location
mkdir -p /usr/share/ublue-os/homebrew/
cp /ctx/custom/brew/*.Brewfile /usr/share/ublue-os/homebrew/

# Consolidate Just Files
mkdir -p /usr/share/ublue-os/just/
find /ctx/custom/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just

# Copy Flatpak preinstall files
mkdir -p /etc/flatpak/preinstall.d/
cp /ctx/custom/flatpaks/*.preinstall /etc/flatpak/preinstall.d/

echo "::endgroup::"

echo "::group:: Custom MOTD"

cp /ctx/build/motd.sh /usr/bin/ublue-motd
chmod +x /usr/bin/ublue-motd

echo "::endgroup::"

echo "::group:: Install Packages"

# Install niri (scrollable-tiling Wayland compositor) from COPR
copr_install_isolated "yalter/niri" niri

# Install DankMaterialShell (DMS) stable release with companion packages
# Note: Manually handling COPRs here because dms depends on danklinux repo
echo "Installing DMS and dependencies..."
dnf5 -y copr enable avengemedia/danklinux
dnf5 -y copr enable avengemedia/dms

# Install packages
dnf5 -y install \
    dms \
    quickshell \
    cliphist \
    matugen \
    wl-clipboard \
    cava

# Disable COPRs to ensure they don't persist
dnf5 -y copr disable avengemedia/dms
dnf5 -y copr disable avengemedia/danklinux

echo "::endgroup::"

echo "::group:: Niri Defaults"

mkdir -p /etc/xdg/niri
cp /usr/share/doc/niri/default-config.kdl /etc/xdg/niri/config.kdl

echo "::endgroup::"

echo "::group:: Install Supporting Utilities"

# Install utilities for niri and DMS
dnf5 install -y \
    fuzzel \
    alacritty \
    swaybg \
    swaylock \
    mako \
    xdg-desktop-portal-gnome \
    xdg-desktop-portal-gtk

echo "::endgroup::"

echo "::group:: Configure Zsh as Default Shell"

dnf5 install -y zsh 2>/dev/null || true

ZSH_PATH=$(which zsh)

if ! grep -qxF "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" >> /etc/shells
fi

sed -i "s|SHELL=/bin/bash|SHELL=$ZSH_PATH|g" /etc/default/useradd

cp /ctx/build/zsh/skel-zshrc /etc/skel/.zshrc

echo "::endgroup::"

echo "::group:: System Configuration"

# Enable/disable systemd services
systemctl enable podman.socket
systemctl enable brew-setup.service
systemctl enable brew-update.timer
systemctl enable brew-upgrade.timer
# Example: systemctl mask unwanted-service

echo "::endgroup::"

echo "Custom build complete!"
