#!/bin/bash
## Licenced under The MIT License (MIT)
## Copyright (c) 2015 Adrian Macneil
set -e

if [[ "$1" == "bitcoind" ]]; then
	mkdir -p "$BITCOIN_DATA"

    cat <<EOF > "$BITCOIN_DATA/bitcoin.conf"
    server=1
    daemon=0
    listen=0
    rest=1
    txindex=1
    rpcuser=forklol
    rpcpassword=forklol
    rpcbind=0.0.0.0
    rpcport=8332
    rpcallowip=::/0
    printtoconsole=1
EOF

    chown bitcoin-btc:bitcoin-btc "$BITCOIN_DATA/bitcoin.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin-btc "$BITCOIN_DATA"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin-btc/.bitcoin
	chown -h bitcoin-btc:bitcoin-btc /home/bitcoin-btc/.bitcoin

	exec gosu bitcoin-btc "$@"
fi

exec "$@"
