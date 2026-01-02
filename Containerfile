# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build /build
COPY custom /custom

## OCI Containers for Artwork, Branding, and Additional System Files
## Following the @projectbluefin/distroless pattern, you can layer in additional
## system files from OCI containers. These are commented out by default for the template.
## Uncomment and customize as needed for your image.

## Artwork and Branding from projectbluefin/common
## This includes wallpapers, themes, and bluefin-specific branding
# COPY --from=ghcr.io/projectbluefin/common:latest /system_files/bluefin /files/bluefin
# COPY --from=ghcr.io/projectbluefin/common:latest /system_files/shared /files/shared

## Homebrew system files from ublue-os/brew
## This provides additional brew-related system integration
# COPY --from=ghcr.io/ublue-os/brew:latest /system_files /files/brew

###############################################################################
# PROJECT NAME CONFIGURATION
###############################################################################
# Name: finpilot
#
# IMPORTANT: Change "finpilot" above to your desired project name.
# This name should be used consistently throughout the repository in:
#   - Justfile: export image_name := env("IMAGE_NAME", "your-name-here")
#   - README.md: # your-name-here (title)
#   - artifacthub-repo.yml: repositoryID: your-name-here
#   - custom/ujust/README.md: localhost/your-name-here:stable (in bootc switch example)
#
# The project name defined here is the single source of truth for your
# custom image's identity. When changing it, update all references above
# to maintain consistency.
###############################################################################

# Base Image
FROM ghcr.io/ublue-os/bluefin:stable@sha256:c9411d9909708d57d8e87c160a308a4a8c795764fb4beff344340755412b9178

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### /opt
## Some bootable images, like Fedora, have /opt symlinked to /var/opt, in order to
## make it mutable/writable for users. However, some packages write files to this directory,
## thus its contents might be wiped out when bootc deploys an image, making it troublesome for
## some packages. Eg, google-chrome, docker-desktop.
##
## Uncomment the following line if one desires to make /opt immutable and be able to be used
## by the package manager.

# RUN rm /opt && mkdir /opt

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build scripts
## the following RUN directive does all the things required to run scripts as recommended.
## Scripts are run in numerical order (10-build.sh, 20-example.sh, etc.)

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build/10-build.sh
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint
