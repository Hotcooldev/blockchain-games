#!/bin/bash
# (C) 2019 Keir Finlow-Bates
# See LICENSE for the licensing details of this software

if [ -z $BASH_VERSION ] ; then
	echo "You must run this script using bash" 1>&2
	exit 1
fi

# uncomment for debug info
set -x

# This script uses python3.
# Activate the virtual python3 environment
source venv/bin/activate

# Proof of concept - so minimal error checking!

# check if game blockchain has already been connected to
# if it is not running, start it
# if it does not exist, create it

# the asset bank is run in the default directory .multichain.
# game nodes are run in a .multichain-player
# ports are configured to allow two blockchain instances to work on one machine

# check if the blockchain node is already configured
if [ -e ~/.multichain-player/game/params.dat ]
then
  echo -e "Game blockchain already exists."
  multichain-cli -datadir=~/.multichain-player -port=19255 -rpcport=19254 game getinfo
  if [ $? -eq 0 ]
  then
    echo -e "Game player blockchain is running."
  else
    echo -e "Starting game player blockchain daemon."
    # run with reindex in case there was a broken shutdown
    multichaind -datadir=~/.multichain-player -port=19255 -rpcport=19254 -reindex=1 game -daemon
  fi

# otherwise sign up, get address activated, and start node
else
  if [ -z "$1" ]
  then
    echo -e "No blockchain address supplied"
	exit 0
  else
    if [ -z "$2" ]
    then
      echo -e "No signup address supplied"
	  exit 0

    else
      # create multichain player instance by connecting to asset bank, extract your local address
      # and send it to the asset bank webserver for automatic connection
      mkdir ~/.multichain-player
      gameblockchain=$1
      myaddress=$(multichaind -datadir=~/.multichain-player -port=19255 -rpcport=19254 $1 | grep -P -i -o -m 1 '(?<=grant )\S+' | sed -r 's/^\W|\W$//g')
      echo -e "My address: $myaddress"
      # POST section to sign up
      curl --header "Content-Type: application/json" --request POST --data '{"address":"'"$myaddress"'"}' $2 
      # wait a few seconds for signup transaction to register
      echo -e "Starting game player blockchain daemon."
      multichaind -datadir=~/.multichain-player -port=19255 -rpcport=19254 game -daemon     
    fi
  fi
fi

# this runs the application
echo -e "Starting client interface"
# start local webserver and browser
# in same shell, so quitting browser kills webserver (except it doesn't)
google-chrome --app=http://localhost:5002 &>/dev/null &
FLASK_APP=client-app.py flask run --host=0.0.0.0 --port 5002



