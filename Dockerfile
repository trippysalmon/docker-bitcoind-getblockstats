# Adapted from https://github.com/jtimon/rpc-explorer/tree/master/docker/bitcoin by Jorge Timón
# Licence: MIT
FROM debian:stretch-slim

# Set the working directory to /build_docker
WORKDIR /build_docker

# Copy the current directory contents into the container at /build_docker
ADD . /build_docker

# Install build tools
RUN set -ex && \
    apt-get update && \
    apt-get upgrade -yqq && \
    apt-get install -yqq curl && \
    apt-get install -yqq \
        make \
        build-essential \
        libtool \
        autotools-dev \
        automake \
        pkg-config \
        libssl-dev \
        libevent-dev \
        bsdmainutils \
        libboost-system-dev \
        libboost-filesystem-dev \
        libboost-chrono-dev \
        libboost-program-options-dev \
        libboost-test-dev \
        libboost-thread-dev \
        libminiupnpc-dev \
        libzmq3-dev \
        gosu

# Install bitcoind with getperblockstats and move it to /bitcoin/bitcoind
RUN curl -L https://github.com/jtimon/bitcoin/archive/b15-rpc-explorer.tar.gz | tar xz && \
    cd bitcoin-b15-rpc-explorer && \
    sh /build_docker/build-bitcoind.sh src/bitcoind && \
    cp src/bitcoind /usr/bin && \
    rm -rf /build_docker

# Create the bitcoin user
RUN groupadd -r bitcoin-btc && useradd -r -m -g bitcoin-btc bitcoin-btc

# Create data directory
ENV BITCOIN_DATA /data
RUN mkdir $BITCOIN_DATA \
	&& chown -R bitcoin-btc:bitcoin-btc $BITCOIN_DATA \
	&& ln -sfn $BITCOIN_DATA /home/bitcoin-btc/.bitcoin \
	&& chown -h bitcoin-btc:bitcoin-btc /home/bitcoin-btc/.bitcoin
VOLUME /data

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR $BITCOIN_DATA

EXPOSE 8332
EXPOSE 8333
