#!/bin/bash
set -e

arch="$1"
git_tag="$2"

if [[ "$arch" == "arm64" ]]; then arch="aarch64"; fi
if [[ "$arch" == "amd64" ]]; then arch="x86-64"; fi

git clone -b ${git_tag} --single-branch https://gitlab.torproject.org/tpo/core/tor.git

cd tor/

./autogen.sh -i

./configure --disable-asciidoc \
            --disable-manpage \
			--disable-html-manual \
			--enable-zstd \
			--enable-lzma \
			--host $arch-linux-gnu

make