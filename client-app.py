#!/usr/bin/env python
# (C) 2019 Keir Finlow-Bates
# See LICENSE for the licensing details of this software

from flask import Flask, render_template, session, request
import sys
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField, SubmitField
from wtforms.validators import DataRequired
from time import sleep
from lib.blockchain import *

app = Flask(__name__)
app.config['SECRET_KEY'] = 'clientapp450i46##'

# precursor string for calling multichain command line interface
multichainCli = "multichain-cli -datadir=~/.multichain-player -port=19255 -rpcport=19254 game "
playerAddress = getAddress(multichainCli)

###
#  WTForms
###

class NameForm(FlaskForm):
    playername = StringField('Playername', validators=[DataRequired()])
    submit = SubmitField('Update')

###
# Routes for player pages
###

# Route for serving up the index page
@app.route('/', methods=['GET', 'POST'])
def index():
    form = NameForm()
   
    if request.method == 'POST':
        if form.validate() == False:
            # validate here
            print("NameForm didn't validate")
        else:
            print("Got the NameForm with " + form.playername.data )
            writeName(multichainCli, form.playername.data)
            sleep(5)

    balances = getBalances(multichainCli)
    return render_template(
        'client/index.html',
        currentname = getNameFromAddress(multichainCli, playerAddress),
        address = playerAddress,
        gold = balances["gold"],
        xp = balances["xp"],
        form = NameForm()
    )    



