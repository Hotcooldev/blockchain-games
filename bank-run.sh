#!/bin/bash
# (C) 2019 Keir Finlow-Bates
# See LICENSE for the licensing details of this software

if [ -z $BASH_VERSION ] ; then
	echo "You must run this script using bash" 1>&2
	exit 1
fi

# uncomment for more debug info
set -x

# This script uses python3.
# Activate the virtual python3 environment
source venv/bin/activate

# Proof of concept - so minimal error checking!

# check if game blockchain is set up and running
# if it is not running, start it
# if it does not exist, create it

# the asset bank is run in the default directory.
# game nodes are run in a custom directory to allow
# two blockchains to work on one machine

# Note: we are assuming that if the game blockchain exists,
# then the relevant digital assets have been created.

if [ -e ~/.multichain/game/params.dat ]
then
  echo -e "Game blockchain already exists."
  multichain-cli game getinfo
  if [ $? -eq 0 ]
  then
    echo -e "Game blockchain is running."
  else
    echo -e "Starting game blockchain daemon."
    # run with reindex in case there was a broken shutdown
    multichaind game -reindex=1 -daemon
  fi
else
  multichain-util create game
  multichaind game -daemon
  # create the initial gold and experience coins
  bankaddress=$(multichain-cli game listpermissions issue | python -c "import json,sys;obj=json.load(sys.stdin);print(obj[0]['address']);")
  sleep 5 # it can take a while for the blockchain to be ready
  multichain-cli game issue $bankaddress '{"name":"gold","open":true}' 10000 1
  multichain-cli game issue $bankaddress '{"name":"xp","open":true}' 10000 1
fi

# this runs the application
echo -e "Starting asset bank interface"
export FLASK_APP=bank-app.py
flask run --host=0.0.0.0 --port ${1:-5050}
