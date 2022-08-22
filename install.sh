#!/bin/bash
# (C) 2019 Keir Finlow-Bates
# See LICENSE for the licensing details of this software

if [ -z $BASH_VERSION ] ; then
	echo -e "You must run this script using bash." 1>&2
	exit 1
fi


# Make sure we are running as root
if [[ $EUID -ne 0 ]]; then
	echo -e "This script must be run as root." 1>&2
	exit 1
fi

echo -e ""
echo -e "--------------------------------------------------------------------------------"
echo -e "Installing MultiChain                                            "
echo -e "--------------------------------------------------------------------------------"
echo -e ""

MCFILE="multichain-2.0-beta-1"
echo  -e "Current multichain is ${MCFILE}"

# Check whether we need to install MultiChain
if test -x /usr/local/bin/multichaind ; then
	echo -e "MultiChain already installed"
else
	cd /tmp
	wget "https://www.multichain.com/download/${MCFILE}.tar.gz"
	tar -xvzf "${MCFILE}.tar.gz"
	cd "${MCFILE}"
	mv multichaind multichain-cli multichain-util /usr/local/bin
fi

echo -e ""
echo -e "--------------------------------------------------------------------------------"
echo -e "Installing curl                                           "
echo -e "--------------------------------------------------------------------------------"
echo -e ""
apt-get install curl

echo -e ""
echo -e "--------------------------------------------------------------------------------"
echo -e "Setting up Python virtual environment                                            "
echo -e "--------------------------------------------------------------------------------"
echo -e ""

# BUG: remove pkg-resources line in requirements.txt if it exists
#     https://stackoverflow.com/questions/39577984/what-is-pkg-resources-0-0-0-in-output-of-pip-freeze-command
sed -i '/pkg-resources==0.0.0/d' ./requirements.txt

# this will probably show python version 2.7
python --version

# install venv
apt-get install python3-venv

# this creates a copy of the python3 environment in a folder called venv
python3 -m venv venv

# this activates the virtual python3 environment
source venv-bank/bin/activate

# which is why this will show version 3.5
python --version

# needs the wheel package first
pip install wheel

# and this now installs all the packages needed for the project in venv
pip install --upgrade -r requirements.txt

# when your project is complete use
# $ pip freeze > requirements.txt
# to make sure the requirements are up to date and the right packages are installed
# To upgrade all pip packages run
# $ pip freeze |sed -ne 's/==.*//p' |xargs pip install -U --

echo -e ""
echo -e "--------------------------------------------------------------------------------"
echo -e "Install complete. Check README.md for instructions on setting up the game"
echo -e "--------------------------------------------------------------------------------"
echo -e ""
