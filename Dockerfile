FROM debian:bullseye-slim AS tor-build

RUN apt-get update && apt-get install -y --no-install-recommends \
    automake \
    git \
	gpg \
	gpg-agent \
	ca-certificates \
	build-essential \
	libevent-dev \
	zlib1g-dev \
	libssl-dev \
	liblzma-dev \
	libzstd-dev \
	pkg-config \
	python3

RUN groupadd -g 101 tor && \
    useradd -u 101 -g 101 -m -d /home/tor tor
	
USER tor
WORKDIR /home/tor

RUN git clone -b tor-0.4.6.9 --single-branch https://git.torproject.org/tor.git

WORKDIR /home/tor/tor
RUN ./autogen.sh -i && \
    ./configure --disable-asciidoc \
                --disable-manpage \
				--disable-html-manual \
				--enable-zstd \
				--enable-lzma && \
	make

USER root
RUN make install

FROM golang:1.17-bullseye AS obfs4-build
RUN git clone -b obfs4proxy-0.0.13 --single-branch https://gitlab.com/yawning/obfs4.git
WORKDIR /go/obfs4/
RUN go build -o obfs4proxy/obfs4proxy ./obfs4proxy

FROM debian:bullseye-slim

RUN groupadd -g 101 tor && \
    useradd -u 101 -g 101 -m -d /home/tor tor && \
	mkdir -p /usr/local/bin \
	         /etc/tor \
			 /usr/local/share/tor \
			 /var/log/tor/log && \
	chown -R 101:101 /var/log/tor /usr/local/share/tor /etc/tor

COPY --from=tor-build /usr/local/bin/* /usr/local/bin/
COPY --from=tor-build /usr/local/share/tor/* /usr/local/share/tor/
COPY --from=obfs4-build /go/obfs4/obfs4proxy/obfs4proxy /usr/bin/

CMD [ "/usr/local/bin/start-tor.sh" ]