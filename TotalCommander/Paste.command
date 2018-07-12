#!/bin/sh

#  Paste.command
#  TotalCommander
#
#  Created by Marcin Karmelita on 24/04/17.
#  Copyright © 2017 Marcin Karmelita. All rights reserved.

echo "*********************************"
echo "Paste the content of pastboard"
echo "*********************************"

pbpaste > "${1}"
