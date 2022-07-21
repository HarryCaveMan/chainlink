#!/bin/bash

start_from_scratch(){
  docker run \
    --name eth-testnet \
    -p 8546:8546 \
    -v ~/Documents/ethereum/.geth-rinkeby:/geth \
    -it \
    ethereum/client-go:stable \
      --rinkeby \
      --ws \
      --ipcdisable \
          --ws.addr 0.0.0.0 \
          --ws.origins="*" \
      --datadir /geth
}

start() {
  docker start -it eth-testnet
}

stop(){
  docker stop eth-testnet
}

restart() {
  stop
  start
}


case $1 in
  start_rom_scratch|start|stop|restart)
    $1
  ;;
  *)
   echo "Invalid operation, supported operations are: start_from_scratch|start|stop|restart"
  ;;
esac