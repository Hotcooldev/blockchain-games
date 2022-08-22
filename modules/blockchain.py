#!/usr/bin/env python
# (C) 2019 Keir Finlow-Bates
# See LICENSE for the licensing details of this software
import subprocess
import json
import sys

###
# Blockchain functions
# Importing file needs to define multichainCli
### 

def getAddress(mc):
    obj = json.loads(subprocess.check_output([mc + "listaddresses"], shell=True))
    address = ""
    for item in obj:
        if item['ismine'] == True:
            address = item['address']
    if address == "":
        sys.exit("My node has no address!")
    return address

def checkIn(mc):
    result = subprocess.check_output([mc + "publish root playerEntry '{\"json\":{\"address\":\"" + getAddress() + "\"}}'"], shell=True)
    return result

def getNameFromAddress(mc, address):
    # use getstreampublishersummary to ensure only player's updates are examined
    obj_s = subprocess.check_output([mc + "getstreampublishersummary root " + address + " jsonobjectmerge"], shell=True)
    obj = json.loads(obj_s)
    print(obj)
    if 'name' in obj['json']:
        name = obj['json']['name']
    else:
        name = "Name not set"
    return name

def writeName(mc, newName):
    wrt = mc + "publish root playerEntry '{\"json\":{\"name\":\"" + newName + "\", \"address\":\"" + getAddress(mc) + "\"}}'"
    obj_s = subprocess.check_output([wrt], shell=True)
    return

def getNodeAddress(mc):
    obj = json.loads(subprocess.check_output([mc + "getinfo"], shell=True))
    nodeaddress = obj['nodeaddress']
    return nodeaddress

def getBalances(mc):
    balances_array = json.loads(subprocess.check_output([mc + "gettotalbalances"], shell=True))
    print(balances_array)
    balances = {"gold": "0", "xp": "0"}
    for item in balances_array:
        balances.update( {item['name']: item['qty']} )
    return balances

##
# Bank functions
##

def signupAddress(mc, address):
    result = subprocess.check_output([mc + " grant " + address + " connect,send,receive"], shell=True)
    return result

def importAddress(mc, address):
    result = subprocess.check_output([mc + "importaddress " + address + " true"], shell=True)
    return result      

def issueAssetToAddress(mc, address, asset, qty):
    result = subprocess.check_output([mc + "issuemore " + address + " " + asset + " " + qty], shell=True)
    return result

def listAddresses(mc):
    result = json.loads(subprocess.check_output([mc + "listaddresses"], shell=True))
    return result





