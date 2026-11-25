#!/bin/bash
set -euo pipefail

arch="$1"

case "$arch" in
  amd64) gnu_arch="x86-64";;
  arm64) gnu_arch="aarch64";;
  *) echo "unsupported architecture: ${arch}" >&2; exit 1;;
esac

dpkg --add-architecture "${arch}"

apt-get update

apt-get install -y --no-install-recommends \
    automake \
    git \
    ca-certificates \
    build-essential \
    libevent-dev:${arch} \
    zlib1g-dev:${arch} \
    libssl-dev:${arch} \
    liblzma-dev:${arch} \
    libzstd-dev:${arch} \
    pkg-config \
    gcc-${gnu_arch}-linux-gnu \
    binutils-${gnu_arch}-linux-gnu
