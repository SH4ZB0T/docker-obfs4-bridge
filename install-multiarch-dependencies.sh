#!/bin/bash
set -e

arch="$1"
pkg_arch="$1"

if [[ "$arch" == "arm64" ]]; then arch="aarch64"; fi
if [[ "$arch" == "amd64" ]]; then arch="x86-64"; fi

dpkg --add-architecture $pkg_arch

apt-get update

apt-get install -y --no-install-recommends \
    automake \
    git \
	gpg \
	gpg-agent \
	ca-certificates \
	build-essential \
	libevent-dev:${pkg_arch} \
	zlib1g-dev:${pkg_arch} \
	libssl-dev:${pkg_arch} \
	liblzma-dev:${pkg_arch} \
	libzstd-dev:${pkg_arch} \
	pkg-config \
    gcc-${arch}-linux-gnu \
    binutils-${arch}-linux-gnu
