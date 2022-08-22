# MultiChain Game Engine
This repository provides a sample setup for a blockchain-backed game, using MultiChain (http://www.multichain.com) as the backend blockchain. See game-blockchain.pdf for details of the game concepts. Currently this is Linux only.

The game contains two main components: the asset bank and the player client.

See https://github.com/kf106/blockchain-games/blob/master/game-blockchain.pdf for more details on how this basic example could be modified to actually generate an interesting game.

## Installation
For either asset bank or client run:

     sudo ./install.sh
     
This sets up the relevant Python virtual environment and install the required packages.

To run the asset bank, execute:

    ./bank-run.sh
    
This starts a local webserver. See http://localhost:5050/admin for the high-tech admin panel (or you can specify a port as the first command line parameter).

To run the player client for the first time, see the signup information at http://localhost:5050/ or if you're restarting the player client just execute:

     ./client-run.sh

## Asset Bank
The asset bank creates the original blockchain, issues assets (gold and xp in this example), issues further gold and xp as the bank's supplies run low, and automates player signup. 

## Player Client
The player client sets up a blockchain node, makes a signup request to the asset bank, and then launches the game. 

Subsequently it just launches the game, as the blockchain node only needs configuration once. If you accidentally close the client, the local webserver runs on port 5002.

