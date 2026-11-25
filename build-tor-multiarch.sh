#!/bin/bash
set -euo pipefail

arch="$1"
git_tag="$2"

case "$arch" in
  amd64) triplet="x86_64-linux-gnu";;
  arm64) triplet="aarch64-linux-gnu";;
  *) echo "unsupported architecture: ${arch}" >&2; exit 1;;
esac

git clone -b "${git_tag}" --single-branch https://gitlab.torproject.org/tpo/core/tor.git

cd tor/

./autogen.sh -i

if [ "${arch}" != "$(dpkg --print-architecture)" ]; then
    export PKG_CONFIG_LIBDIR="/usr/lib/${triplet}/pkgconfig:/usr/share/pkgconfig"
fi

./configure --disable-asciidoc \
            --disable-manpage \
            --disable-html-manual \
            --enable-zstd \
            --enable-lzma \
            --host "${triplet}"

make